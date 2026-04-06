module {
  func.func @gesummv_hir(%arg0: i32 {hir.delay = 0 : i64}, %arg1: i32 {hir.delay = 0 : i64}, %arg2: memref<8xi32> {hir.memref.ports = [{wr_latency = 1 : i64}]}, %arg3: memref<8x8xi32> {hir.memref.ports = [{rd_latency = 1 : i64}]}, %arg4: memref<8x8xi32> {hir.memref.ports = [{rd_latency = 1 : i64}]}, %arg5: memref<8xi32> {hir.memref.ports = [{rd_latency = 1 : i64}]}, %arg6: memref<8xi32> {hir.memref.ports = [{wr_latency = 1 : i64}]}) attributes {argNames = ["alpha", "beta", "tmp", "A", "B", "X", "Y"], hwAccel} {
    %c0_i32 = arith.constant 0 : i32
    %alloca = memref.alloca() {hir.memref.ports = [{rd_latency = 0 : i64}, {wr_latency = 1 : i64}], mem_kind = "reg"} : memref<1xi32>
    %alloca_0 = memref.alloca() {hir.memref.ports = [{rd_latency = 0 : i64}, {wr_latency = 1 : i64}], mem_kind = "reg"} : memref<1xi32>
    affine.for %arg7 = 0 to 8 {
      affine.store %c0_i32, %alloca_0[0] : memref<1xi32>
      affine.store %c0_i32, %alloca[0] : memref<1xi32>
      affine.for %arg8 = 0 to 8 {
        %5 = affine.load %arg5[%arg8] {result_delays = [1]} : memref<8xi32>
        %6 = affine.load %arg3[%arg7, %arg8] {result_delays = [1]} : memref<8x8xi32>
        %7 = func.call @mul_i32(%6, %5) {result_delays = [1]} : (i32, i32) -> i32
        %8 = affine.load %arg4[%arg7, %arg8] {result_delays = [1]} : memref<8x8xi32>
        %9 = func.call @mul_i32(%8, %5) {result_delays = [1]} : (i32, i32) -> i32
        %10 = affine.load %alloca_0[0] {result_delays = [0]} : memref<1xi32>
        %11 = func.call @add_i32(%10, %7) {result_delays = [0]} : (i32, i32) -> i32
        affine.store %11, %alloca_0[0] : memref<1xi32>
        %12 = affine.load %alloca[0] {result_delays = [0]} : memref<1xi32>
        %13 = func.call @add_i32(%12, %9) {result_delays = [0]} : (i32, i32) -> i32
        affine.store %13, %alloca[0] : memref<1xi32>
      } {II = 1 : i64}
      %0 = affine.load %alloca_0[0] {result_delays = [0]} : memref<1xi32>
      affine.store %0, %arg2[%arg7] : memref<8xi32>
      %1 = affine.load %alloca[0] {result_delays = [0]} : memref<1xi32>
      %2 = func.call @mul_i32(%arg0, %0) {result_delays = [1]} : (i32, i32) -> i32
      %3 = func.call @mul_i32(%arg1, %1) {result_delays = [1]} : (i32, i32) -> i32
      %4 = func.call @add_i32(%2, %3) {result_delays = [0]} : (i32, i32) -> i32
      affine.store %4, %arg6[%arg7] : memref<8xi32>
    } {II = 18 : i64}
    return
  }
  func.func private @mul_i32(i32 {hir.delay = 0 : i64}, i32 {hir.delay = 0 : i64}) -> (i32 {hir.delay = 1 : i64}) attributes {argNames = ["a", "b"], llvm.linkage = #llvm.linkage<external>, resultNames = ["out"]}
  func.func private @add_i32(i32 {hir.delay = 0 : i64}, i32 {hir.delay = 0 : i64}) -> (i32 {hir.delay = 0 : i64}) attributes {argNames = ["a", "b"], llvm.linkage = #llvm.linkage<external>, resultNames = ["out"]}
}

