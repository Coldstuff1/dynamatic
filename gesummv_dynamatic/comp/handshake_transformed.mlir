module {
  handshake.func @gesummv(%arg0: i32 {hls.INTERFACE_LATENCY = 0 : i64}, %arg1: i32 {hls.INTERFACE_LATENCY = 0 : i64}, %arg2: memref<8xi32> {hls.INTERFACE_PORT = "tmp", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}, %arg3: memref<64xi32> {hls.INTERFACE_PORT = "A", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg4: memref<64xi32> {hls.INTERFACE_PORT = "B", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg5: memref<8xi32> {hls.INTERFACE_PORT = "X", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg6: memref<8xi32> {hls.INTERFACE_PORT = "Y", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}, %arg7: none, ...) -> none attributes {argNames = ["alpha", "beta", "tmp", "A", "B", "X", "Y", "start"], resNames = ["out0"], resultNames = []} {
    %done = mem_controller[%arg6 : memref<8xi32>] (%86#1, %addressResult_26, %dataResult_27) {connectedBlocks = [3 : i32], name = #handshake.name<"mem_controller0">} : (i32, i32, i32) -> none
    %memOutputs, %done_0 = mem_controller[%arg5 : memref<8xi32>] (%addressResult) {connectedBlocks = [2 : i32], name = #handshake.name<"mem_controller1">} : (i32) -> (i32, none)
    %memOutputs_1, %done_2 = mem_controller[%arg4 : memref<64xi32>] (%addressResult_10) {connectedBlocks = [2 : i32], name = #handshake.name<"mem_controller2">} : (i32) -> (i32, none)
    %memOutputs_3, %done_4 = mem_controller[%arg3 : memref<64xi32>] (%addressResult_8) {connectedBlocks = [2 : i32], name = #handshake.name<"mem_controller3">} : (i32) -> (i32, none)
    %done_5 = mem_controller[%arg2 : memref<8xi32>] (%86#0, %addressResult_24, %dataResult_25) {connectedBlocks = [3 : i32], name = #handshake.name<"mem_controller4">} : (i32, i32, i32) -> none
    %0 = merge %arg0 {bb = 0 : ui32, name = #handshake.name<"merge0">} : i32
    %1 = merge %arg1 {bb = 0 : ui32, name = #handshake.name<"merge1">} : i32
    %2 = merge %arg7 {bb = 0 : ui32, name = #handshake.name<"merge2">} : none
    %3:2 = fork [2] %2 {bb = 0 : ui32, name = #handshake.name<"fork0">} : none
    %4 = constant %3#1 {bb = 0 : ui32, name = #handshake.name<"constant0">, value = false} : i1
    %5 = br %4 {bb = 0 : ui32, name = #handshake.name<"br0">} : i1
    %6 = arith.extsi %5 {bb = 0 : ui32, name = #handshake.name<"extsi8">} : i1 to i4
    %7 = br %0 {bb = 0 : ui32, name = #handshake.name<"br3">} : i32
    %8 = br %1 {bb = 0 : ui32, name = #handshake.name<"br4">} : i32
    %9 = br %3#0 {bb = 0 : ui32, name = #handshake.name<"br5">} : none
    %10 = mux %13#0 [%trueResult_28, %6] {bb = 1 : ui32, name = #handshake.name<"mux9">} : i1, i4
    %11 = mux %13#2 [%trueResult_30, %7] {bb = 1 : ui32, name = #handshake.name<"mux1">} : i1, i32
    %12 = mux %13#1 [%trueResult_32, %8] {bb = 1 : ui32, name = #handshake.name<"mux2">} : i1, i32
    %result, %index = control_merge %trueResult_34, %9 {bb = 1 : ui32, name = #handshake.name<"control_merge4">} : none, i1
    %13:3 = fork [3] %index {bb = 1 : ui32, name = #handshake.name<"fork1">} : i1
    %14:2 = fork [2] %result {bb = 1 : ui32, name = #handshake.name<"fork2">} : none
    %15 = constant %14#0 {bb = 1 : ui32, name = #handshake.name<"constant1">, value = false} : i1
    %16:3 = fork [3] %15 {bb = 1 : ui32, name = #handshake.name<"fork3">} : i1
    %17 = br %16#0 {bb = 1 : ui32, name = #handshake.name<"br1">} : i1
    %18 = arith.extsi %17 {bb = 1 : ui32, name = #handshake.name<"extsi9">} : i1 to i4
    %19 = br %16#1 {bb = 1 : ui32, name = #handshake.name<"br13">} : i1
    %20 = arith.extsi %19 {bb = 1 : ui32, name = #handshake.name<"extsi10">} : i1 to i32
    %21 = br %16#2 {bb = 1 : ui32, name = #handshake.name<"br14">} : i1
    %22 = arith.extsi %21 {bb = 1 : ui32, name = #handshake.name<"extsi11">} : i1 to i32
    %23 = br %11 {bb = 1 : ui32, name = #handshake.name<"br9">} : i32
    %24 = br %12 {bb = 1 : ui32, name = #handshake.name<"br10">} : i32
    %25 = br %10 {bb = 1 : ui32, name = #handshake.name<"br15">} : i4
    %26 = br %14#1 {bb = 1 : ui32, name = #handshake.name<"br12">} : none
    %27 = mux %41#1 [%trueResult, %18] {bb = 2 : ui32, name = #handshake.name<"mux10">} : i1, i4
    %28:4 = fork [4] %27 {bb = 2 : ui32, name = #handshake.name<"fork4">} : i4
    %29 = arith.extsi %28#0 {bb = 2 : ui32, name = #handshake.name<"extsi12">} : i4 to i8
    %30 = arith.extsi %28#1 {bb = 2 : ui32, name = #handshake.name<"extsi13">} : i4 to i8
    %31 = arith.extsi %28#2 {bb = 2 : ui32, name = #handshake.name<"extsi14">} : i4 to i5
    %32 = arith.extsi %28#3 {bb = 2 : ui32, name = #handshake.name<"extsi15">} : i4 to i32
    %33 = mux %41#5 [%trueResult_12, %22] {bb = 2 : ui32, name = #handshake.name<"mux4">} : i1, i32
    %34 = mux %41#4 [%trueResult_14, %20] {bb = 2 : ui32, name = #handshake.name<"mux5">} : i1, i32
    %35 = mux %41#3 [%trueResult_16, %23] {bb = 2 : ui32, name = #handshake.name<"mux6">} : i1, i32
    %36 = mux %41#2 [%trueResult_18, %24] {bb = 2 : ui32, name = #handshake.name<"mux7">} : i1, i32
    %37 = mux %41#0 [%trueResult_20, %25] {bb = 2 : ui32, name = #handshake.name<"mux11">} : i1, i4
    %38:3 = fork [3] %37 {bb = 2 : ui32, name = #handshake.name<"fork5">} : i4
    %39 = arith.extsi %38#1 {bb = 2 : ui32, name = #handshake.name<"extsi16">} : i4 to i7
    %40 = arith.extsi %38#2 {bb = 2 : ui32, name = #handshake.name<"extsi17">} : i4 to i7
    %result_6, %index_7 = control_merge %trueResult_22, %26 {bb = 2 : ui32, name = #handshake.name<"control_merge5">} : none, i1
    %41:6 = fork [6] %index_7 {bb = 2 : ui32, name = #handshake.name<"fork6">} : i1
    %42 = source {bb = 2 : ui32, name = #handshake.name<"source0">}
    %43 = constant %42 {bb = 2 : ui32, name = #handshake.name<"constant4">, value = 3 : i3} : i3
    %44:2 = fork [2] %43 {bb = 2 : ui32, name = #handshake.name<"fork7">} : i3
    %45 = arith.extui %44#0 {bb = 2 : ui32, name = #handshake.name<"extui0">} : i3 to i7
    %46 = arith.extui %44#1 {bb = 2 : ui32, name = #handshake.name<"extui1">} : i3 to i7
    %47 = source {bb = 2 : ui32, name = #handshake.name<"source1">}
    %48 = constant %47 {bb = 2 : ui32, name = #handshake.name<"constant12">, value = 8 : i5} : i5
    %49 = source {bb = 2 : ui32, name = #handshake.name<"source2">}
    %50 = constant %49 {bb = 2 : ui32, name = #handshake.name<"constant13">, value = 1 : i2} : i2
    %51 = arith.extsi %50 {bb = 2 : ui32, name = #handshake.name<"extsi18">} : i2 to i5
    %addressResult, %dataResult = mc_load[%32] %memOutputs {bb = 2 : ui32, name = #handshake.name<"mc_load0">} : i32, i32
    %52:2 = fork [2] %dataResult {bb = 2 : ui32, name = #handshake.name<"fork8">} : i32
    %53 = arith.shli %40, %46 {bb = 2 : ui32, name = #handshake.name<"shli2">} : i7
    %54 = arith.extsi %53 {bb = 2 : ui32, name = #handshake.name<"extsi19">} : i7 to i8
    %55 = arith.addi %30, %54 {bb = 2 : ui32, name = #handshake.name<"addi7">} : i8
    %56 = arith.extsi %55 {bb = 2 : ui32, name = #handshake.name<"extsi20">} : i8 to i32
    %addressResult_8, %dataResult_9 = mc_load[%56] %memOutputs_3 {bb = 2 : ui32, name = #handshake.name<"mc_load1">} : i32, i32
    %57 = arith.muli %dataResult_9, %52#1 {bb = 2 : ui32, name = #handshake.name<"muli0">} : i32
    %58 = arith.shli %39, %45 {bb = 2 : ui32, name = #handshake.name<"shli3">} : i7
    %59 = arith.extsi %58 {bb = 2 : ui32, name = #handshake.name<"extsi21">} : i7 to i8
    %60 = arith.addi %29, %59 {bb = 2 : ui32, name = #handshake.name<"addi8">} : i8
    %61 = arith.extsi %60 {bb = 2 : ui32, name = #handshake.name<"extsi22">} : i8 to i32
    %addressResult_10, %dataResult_11 = mc_load[%61] %memOutputs_1 {bb = 2 : ui32, name = #handshake.name<"mc_load2">} : i32, i32
    %62 = arith.muli %dataResult_11, %52#0 {bb = 2 : ui32, name = #handshake.name<"muli1">} : i32
    %63 = arith.addi %34, %57 {bb = 2 : ui32, name = #handshake.name<"addi0">} : i32
    %64 = arith.addi %33, %62 {bb = 2 : ui32, name = #handshake.name<"addi1">} : i32
    %65 = arith.addi %31, %51 {bb = 2 : ui32, name = #handshake.name<"addi9">} : i5
    %66:2 = fork [2] %65 {bb = 2 : ui32, name = #handshake.name<"fork9">} : i5
    %67 = arith.trunci %66#0 {bb = 2 : ui32, name = #handshake.name<"trunci0">} : i5 to i4
    %68 = arith.cmpi ult, %66#1, %48 {bb = 2 : ui32, name = #handshake.name<"cmpi2">} : i5
    %69:7 = fork [7] %68 {bb = 2 : ui32, name = #handshake.name<"fork10">} : i1
    %trueResult, %falseResult = cond_br %69#0, %67 {bb = 2 : ui32, name = #handshake.name<"cond_br0">} : i4
    sink %falseResult {name = #handshake.name<"sink0">} : i4
    %trueResult_12, %falseResult_13 = cond_br %69#2, %64 {bb = 2 : ui32, name = #handshake.name<"cond_br3">} : i32
    %trueResult_14, %falseResult_15 = cond_br %69#3, %63 {bb = 2 : ui32, name = #handshake.name<"cond_br4">} : i32
    %trueResult_16, %falseResult_17 = cond_br %69#4, %35 {bb = 2 : ui32, name = #handshake.name<"cond_br5">} : i32
    %trueResult_18, %falseResult_19 = cond_br %69#5, %36 {bb = 2 : ui32, name = #handshake.name<"cond_br6">} : i32
    %trueResult_20, %falseResult_21 = cond_br %69#1, %38#0 {bb = 2 : ui32, name = #handshake.name<"cond_br1">} : i4
    %trueResult_22, %falseResult_23 = cond_br %69#6, %result_6 {bb = 2 : ui32, name = #handshake.name<"cond_br8">} : none
    %70 = merge %falseResult_17 {bb = 3 : ui32, name = #handshake.name<"merge3">} : i32
    %71:2 = fork [2] %70 {bb = 3 : ui32, name = #handshake.name<"fork11">} : i32
    %72 = merge %falseResult_19 {bb = 3 : ui32, name = #handshake.name<"merge4">} : i32
    %73:2 = fork [2] %72 {bb = 3 : ui32, name = #handshake.name<"fork12">} : i32
    %74 = merge %falseResult_21 {bb = 3 : ui32, name = #handshake.name<"merge8">} : i4
    %75:2 = fork [2] %74 {bb = 3 : ui32, name = #handshake.name<"fork13">} : i4
    %76 = arith.extsi %75#0 {bb = 3 : ui32, name = #handshake.name<"extsi23">} : i4 to i5
    %77 = arith.extsi %75#1 {bb = 3 : ui32, name = #handshake.name<"extsi24">} : i4 to i32
    %78:2 = fork [2] %77 {bb = 3 : ui32, name = #handshake.name<"fork14">} : i32
    %79 = merge %falseResult_15 {bb = 3 : ui32, name = #handshake.name<"merge6">} : i32
    %80:2 = fork [2] %79 {bb = 3 : ui32, name = #handshake.name<"fork15">} : i32
    %81 = merge %falseResult_13 {bb = 3 : ui32, name = #handshake.name<"merge7">} : i32
    %82 = merge %falseResult_23 {bb = 3 : ui32, name = #handshake.name<"merge9">} : none
    %83:2 = fork [2] %82 {bb = 3 : ui32, name = #handshake.name<"fork16">} : none
    %84 = constant %83#1 {bb = 3 : ui32, name = #handshake.name<"constant14">, value = 1 : i2} : i2
    %85 = arith.extsi %84 {bb = 3 : ui32, name = #handshake.name<"extsi5">} : i2 to i32
    %86:2 = fork [2] %85 {bb = 3 : ui32, name = #handshake.name<"fork17">} : i32
    %87 = source {bb = 3 : ui32, name = #handshake.name<"source3">}
    %88 = constant %87 {bb = 3 : ui32, name = #handshake.name<"constant16">, value = 8 : i5} : i5
    %89 = source {bb = 3 : ui32, name = #handshake.name<"source4">}
    %90 = constant %89 {bb = 3 : ui32, name = #handshake.name<"constant17">, value = 1 : i2} : i2
    %91 = arith.extsi %90 {bb = 3 : ui32, name = #handshake.name<"extsi25">} : i2 to i5
    %addressResult_24, %dataResult_25 = mc_store[%78#0] %80#1 {bb = 3 : ui32, name = #handshake.name<"mc_store0">} : i32, i32
    %92 = arith.muli %71#1, %80#0 {bb = 3 : ui32, name = #handshake.name<"muli2">} : i32
    %93 = arith.muli %73#1, %81 {bb = 3 : ui32, name = #handshake.name<"muli3">} : i32
    %94 = arith.addi %92, %93 {bb = 3 : ui32, name = #handshake.name<"addi2">} : i32
    %addressResult_26, %dataResult_27 = mc_store[%78#1] %94 {bb = 3 : ui32, name = #handshake.name<"mc_store1">} : i32, i32
    %95 = arith.addi %76, %91 {bb = 3 : ui32, name = #handshake.name<"addi10">} : i5
    %96:2 = fork [2] %95 {bb = 3 : ui32, name = #handshake.name<"fork18">} : i5
    %97 = arith.trunci %96#0 {bb = 3 : ui32, name = #handshake.name<"trunci1">} : i5 to i4
    %98 = arith.cmpi ult, %96#1, %88 {bb = 3 : ui32, name = #handshake.name<"cmpi3">} : i5
    %99:4 = fork [4] %98 {bb = 3 : ui32, name = #handshake.name<"fork19">} : i1
    %trueResult_28, %falseResult_29 = cond_br %99#0, %97 {bb = 3 : ui32, name = #handshake.name<"cond_br20">} : i4
    sink %falseResult_29 {name = #handshake.name<"sink1">} : i4
    %trueResult_30, %falseResult_31 = cond_br %99#1, %71#0 {bb = 3 : ui32, name = #handshake.name<"cond_br16">} : i32
    sink %falseResult_31 {name = #handshake.name<"sink2">} : i32
    %trueResult_32, %falseResult_33 = cond_br %99#2, %73#0 {bb = 3 : ui32, name = #handshake.name<"cond_br17">} : i32
    sink %falseResult_33 {name = #handshake.name<"sink3">} : i32
    %trueResult_34, %falseResult_35 = cond_br %99#3, %83#0 {bb = 3 : ui32, name = #handshake.name<"cond_br18">} : none
    %100 = merge %falseResult_35 {bb = 4 : ui32, name = #handshake.name<"merge10">} : none
    %101 = d_return {bb = 4 : ui32, name = #handshake.name<"d_return0">} %100 : none
    end {bb = 4 : ui32, name = #handshake.name<"end0">} %101, %done, %done_0, %done_2, %done_4, %done_5 : none, none, none, none, none, none
  }
}

