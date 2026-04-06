# AffineToHIRPrep Gap Analysis

Compares **`gesummv_hir_from_prep.mlir`** (current prep-pass output) against
**`gesummv_hir.mlir`** (hand-written target HIR).

---

## Summary Table

| # | What | In target HIR | In prep output | Action needed |
|---|------|--------------|----------------|---------------|
| 1 | `func.call` → `arith` ops | `arith.muli`/`arith.addi` with `{result_delays, hir_function}` | `func.call @mul_i32`/`@add_i32` with `{result_delays}` | Replace `func.call` with equivalent `arith` op + `hir_function` attr |
| 2 | `result_delays` type | `[1]` (bare int, no type) | `[1 : i32]` (typed integer) | Emit `I64` attrs not `I32`, or strip the type suffix |
| 3 | `affine.load` `{result_delays}` | Present on every load | Absent | Annotate loads with `{result_delays=[<latency>]}` from port info |
| 4 | `hls.*` attrs on non-func args | Removed (not present) | Still present alongside `hir.*` | Strip `hls.*` attrs after converting |
| 5 | Scalar `func.func private` declarations | Replaced entirely by `hir.func.extern` | Still `func.func private` | Emit `hir.func.extern` ops and erase the `func.func private` |
| 6 | `alloca` init store | `memref<1xi32>`, indexed `[0]`, no preceding `undef` store | Current output keeps an `llvm.mlir.undef` store *before* the loop | Remove / avoid the undef initialiser |
| 7 | `affine.for` `{II}` attribute | Present on both loops | Missing (test file has no `hls.PIPELINE_II`) | See open question #1 |
| 8 | `hwAccel` attribution | Set on *every* non-external func generically | Currently hard-coded to `"gesummv_hir"` | Generalise: set on all non-external funcs |
| 9 | `hls.INTERFACE_LATENCY` on non-memref args (alpha, beta) | Becomes `{hir.delay=0}` only | Both `hir.delay` and `hls.INTERFACE_LATENCY` coexist | Remove `hls.INTERFACE_LATENCY` after renaming |
| 10 | `resultNames` / `argNames` on top-level func | Not present in target HIR (kept only on `hir.func.extern`) | Present but harmless | Target file omits them; consider whether downstream passes care |
| 11 | `llvm.linkage` attr on top-level func | Absent | Present | Remove it |

---

## Detailed Differences

### 1. `func.call` → `arith` op + `hir_function` attr  *(most significant)*

**Target HIR** represents extern-function calls as standard `arith` operations
annotated with `hir_function`:

```mlir
%10 = arith.muli %8, %9  {result_delays=[1], hir_function=@mul_i32} : i32
%14 = arith.addi %13, %10 {result_delays=[0], hir_function=@add_i32} : i32
```

**Prep output** keeps them as `func.call`:

```mlir
%8 = func.call @mul_i32(%7, %6) {result_delays = [1 : i32]} : (i32, i32) -> i32
%12 = func.call @add_i32(%11, %8) {result_delays = [0 : i32]} : (i32, i32) -> i32
```

**What needs to happen:**
Walk every `func::CallOp` whose callee is an extern. Determine the matching
`arith` opcode from the callee name (or from an attribute). Create the
corresponding `arith.muli` / `arith.addi` with `{result_delays, hir_function}`
and replace the call.

> **❓ Open Question 1** – How is the mapping from extern-function name to `arith`
> opcode determined? In the example `mul_i32` → `arith.muli` and `add_i32` →
> `arith.addi`. Is this based on the function name (substring match), on a
> pragma/attribute, or does the target HIR file need to be authored by hand for
> this step? Can a generic `hir.call`-style op be used instead of `arith`?

---

### 2. `result_delays` integer type (`i32` vs bare)

Prep output emits `[1 : i32]`; the target HIR has `[1]` (no explicit type).
This is likely just an MLIR printer difference for i64 vs i32 attrs. Change the
`builder.getI32IntegerAttr(delay)` call to `builder.getI64IntegerAttr(delay)`.

---

### 3. Missing `{result_delays}` on `affine.load`

Target HIR annotates *every* `affine.load` with the port's read latency:

```mlir
%8 = affine.load %arg3[%arg7, %arg8] {result_delays=[1]} : memref<8x8xi32>
%13 = affine.load %2[0] {result_delays=[0]} : memref<1xi32>
```

The prep output has no such annotation. The latency is already available in the
`hir.memref.ports` attribute that was just set on the memref.

**What needs to happen:** After setting `hir.memref.ports`, walk all
`affine::AffineLoadOp`s, look up the `rd_latency` in the port list of the
accessed memref's defining op (or function argument attr), and set
`{result_delays=[<latency>]}` on the load.

---

### 4. Leftover `hls.*` attributes on function arguments

After the port conversion, args still carry both `hir.memref.ports` *and*
`hls.INTERFACE_WR_LATENCY` / `hls.INTERFACE_RD_LATENCY` etc. The target HIR
has only `hir.*`. Strip `hls.INTERFACE_WR_LATENCY`, `hls.INTERFACE_RD_LATENCY`,
`hls.INTERFACE_STORAGE_TYPE`, `hls.INTERFACE_PORT`, and `hls.INTERFACE_LATENCY`
after their HIR equivalents have been set.

---

### 5. `func.func private` → `hir.func.extern`

Target HIR uses a dedicated `hir.func.extern` op:

```mlir
hir.func.extern @mul_i32 at %t(%a:i32, %b:i32) ->(%out:i32 delay 1) {argNames = [...]}
hir.func.extern @add_i32 at %t(%a:i32, %b:i32) ->(%out:i32){argNames = [...]}
```

The prep output keeps `func.func private` declarations:

```mlir
func.func private @mul_i32(i32 {hir.delay=0}, ...) -> (i32 {hir.delay=1, ...}) ...
```

**What needs to happen:** For each external `func.func` that has been annotated,
create a `hir::FuncExternOp` with the right operands and erase the original.

> **❓ Open Question 2** – Is `hir::FuncExternOp` already defined in the CIRCT
> HIR dialect (i.e., does `circt/Dialect/HIR/IR/HIR.h` expose a
> `FuncExternOp` builder)? If not, should the prep pass just leave the
> `func.func private` and let a later pass handle this, or does it need to be
> created here?

---

### 6. Spurious `llvm.mlir.undef` store before the outer loop

The affine input has:
```mlir
%0 = llvm.mlir.undef : i32
%alloca = memref.alloca() : memref<i32>
affine.store %0, %alloca[] : memref<i32>   ← this undef store
```

This becomes in the prep output:
```mlir
%0 = llvm.mlir.undef : i32
%alloca = memref.alloca() {...} : memref<1xi32>
affine.store %0, %alloca[0] : memref<1xi32>  ← still present
```

The target HIR omits it entirely (the alloca is `%2` and `%1`; no undef op or
initial store outside the loop appears).

**What needs to happen:** Detect stores of `llvm.mlir.undef` into the converted
allocas and erase them (and the undef op itself if it has no other uses).

---

### 7. `{II}` on `affine.for` loops

Target HIR has `{II=18}` and `{II=1}` on the two loops. The prep pass already
looks for `hls.PIPELINE_II` and renames it to `II`, but the affine output
(`gesummv_affine.mlir`) **does not include `hls.PIPELINE_II`** on the loops.

> **❓ Open Question 3** – Where does the pipeline II pragma get attached to the
> `affine.for` ops? Looking at `HLSPragma.cc`, it only builds a generic
> `NamedAttr` list; something upstream (in Polygeist's clang C parser) must
> attach `hls.PIPELINE_II` to the loop. Since it is absent in
> `gesummv_affine.mlir`, is Polygeist not yet emitting it, or is the test file
> generated without pragma support enabled? Should the prep pass look for a
> different attribute name?

---

### 8. `hwAccel` hard-coded to `"gesummv_hir"`

The prep pass sets `hwAccel` only when `func.getName() == "gesummv_hir"`. It
should be set on **every** non-external function (or perhaps every function that
carries `hls.INTERFACE_*` port attributes). Simple fix: remove the name check.

---

### 9 & 10. Residual `hls.*`, `llvm.linkage`, `argNames`/`resultNames` on top-level func

Target HIR has none of these on the main `func.func`. After all conversions,
strip:
- `hls.INTERFACE_LATENCY` from scalar args
- `llvm.linkage`
- `argNames` / `resultNames` (if downstream passes don't require them)

---

## What the Prep Pass Already Does Correctly

- ✅ Converting `memref<i32>` → `memref<1xi32>` with `mem_kind="reg"` and `hir.memref.ports`
- ✅ Reindexing scalar alloca loads/stores to index `[0]`
- ✅ Adding `hir.delay` to scalar function arguments
- ✅ Adding `hir.memref.ports` to memref arguments from `hls.INTERFACE_*`
- ✅ Annotating `func.call` results with `result_delays`
- ✅ Setting `hwAccel` on the top-level function

---

## Open Questions Summary

| # | Question |
|---|---------|
| OQ1 | How is the `func.call` → `arith` opcode mapping determined? Name-based, pragma, or manual? |
| OQ2 | Is `hir::FuncExternOp` available in the current CIRCT HIR dialect build? |
| OQ3 | Why is `hls.PIPELINE_II` absent from `gesummv_affine.mlir`? Is Polygeist not emitting it yet? |
