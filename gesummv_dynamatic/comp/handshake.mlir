module {
  handshake.func @gesummv(%arg0: i32 {hls.INTERFACE_LATENCY = 0 : i64}, %arg1: i32 {hls.INTERFACE_LATENCY = 0 : i64}, %arg2: memref<8xi32> {hls.INTERFACE_PORT = "tmp", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}, %arg3: memref<64xi32> {hls.INTERFACE_PORT = "A", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg4: memref<64xi32> {hls.INTERFACE_PORT = "B", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg5: memref<8xi32> {hls.INTERFACE_PORT = "X", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg6: memref<8xi32> {hls.INTERFACE_PORT = "Y", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}, %arg7: none, ...) -> none attributes {argNames = ["alpha", "beta", "tmp", "A", "B", "X", "Y", "start"], resNames = ["out0"], resultNames = []} {
    %done = mem_controller[%arg6 : memref<8xi32>] (%47, %addressResult_40, %dataResult_41) {connectedBlocks = [3 : i32], name = #handshake.name<"mem_controller0">} : (i32, index, i32) -> none
    %memOutputs, %done_0 = mem_controller[%arg5 : memref<8xi32>] (%addressResult) {connectedBlocks = [2 : i32], name = #handshake.name<"mem_controller1">} : (index) -> (i32, none)
    %memOutputs_1, %done_2 = mem_controller[%arg4 : memref<64xi32>] (%addressResult_10) {connectedBlocks = [2 : i32], name = #handshake.name<"mem_controller2">} : (index) -> (i32, none)
    %memOutputs_3, %done_4 = mem_controller[%arg3 : memref<64xi32>] (%addressResult_8) {connectedBlocks = [2 : i32], name = #handshake.name<"mem_controller3">} : (index) -> (i32, none)
    %done_5 = mem_controller[%arg2 : memref<8xi32>] (%48, %addressResult_38, %dataResult_39) {connectedBlocks = [3 : i32], name = #handshake.name<"mem_controller4">} : (i32, index, i32) -> none
    %0 = merge %arg0 {bb = 0 : ui32, name = #handshake.name<"merge0">} : i32
    %1 = merge %arg1 {bb = 0 : ui32, name = #handshake.name<"merge1">} : i32
    %2 = merge %arg7 {bb = 0 : ui32, name = #handshake.name<"merge2">} : none
    %3 = constant %2 {bb = 0 : ui32, name = #handshake.name<"constant0">, value = 0 : index} : index
    %4 = br %3 {bb = 0 : ui32, name = #handshake.name<"br2">} : index
    %5 = br %0 {bb = 0 : ui32, name = #handshake.name<"br3">} : i32
    %6 = br %1 {bb = 0 : ui32, name = #handshake.name<"br4">} : i32
    %7 = br %2 {bb = 0 : ui32, name = #handshake.name<"br5">} : none
    %8 = mux %index [%trueResult_42, %4] {bb = 1 : ui32, name = #handshake.name<"mux0">} : index, index
    %9 = mux %index [%trueResult_44, %5] {bb = 1 : ui32, name = #handshake.name<"mux1">} : index, i32
    %10 = mux %index [%trueResult_46, %6] {bb = 1 : ui32, name = #handshake.name<"mux2">} : index, i32
    %result, %index = control_merge %trueResult_48, %7 {bb = 1 : ui32, name = #handshake.name<"control_merge0">} : none, index
    %11 = constant %result {bb = 1 : ui32, name = #handshake.name<"constant1">, value = 0 : i32} : i32
    %12 = constant %result {bb = 1 : ui32, name = #handshake.name<"constant3">, value = 0 : index} : index
    %13 = br %12 {bb = 1 : ui32, name = #handshake.name<"br6">} : index
    %14 = br %11 {bb = 1 : ui32, name = #handshake.name<"br7">} : i32
    %15 = br %11 {bb = 1 : ui32, name = #handshake.name<"br8">} : i32
    %16 = br %9 {bb = 1 : ui32, name = #handshake.name<"br9">} : i32
    %17 = br %10 {bb = 1 : ui32, name = #handshake.name<"br10">} : i32
    %18 = br %8 {bb = 1 : ui32, name = #handshake.name<"br11">} : index
    %19 = br %result {bb = 1 : ui32, name = #handshake.name<"br12">} : none
    %20 = mux %index_7 [%trueResult, %13] {bb = 2 : ui32, name = #handshake.name<"mux3">} : index, index
    %21 = mux %index_7 [%trueResult_12, %15] {bb = 2 : ui32, name = #handshake.name<"mux4">} : index, i32
    %22 = mux %index_7 [%trueResult_14, %14] {bb = 2 : ui32, name = #handshake.name<"mux5">} : index, i32
    %23 = mux %index_7 [%trueResult_16, %16] {bb = 2 : ui32, name = #handshake.name<"mux6">} : index, i32
    %24 = mux %index_7 [%trueResult_18, %17] {bb = 2 : ui32, name = #handshake.name<"mux7">} : index, i32
    %25 = mux %index_7 [%trueResult_20, %18] {bb = 2 : ui32, name = #handshake.name<"mux8">} : index, index
    %result_6, %index_7 = control_merge %trueResult_22, %19 {bb = 2 : ui32, name = #handshake.name<"control_merge1">} : none, index
    %26 = source {bb = 2 : ui32, name = #handshake.name<"source0">}
    %27 = constant %26 {bb = 2 : ui32, name = #handshake.name<"constant4">, value = 3 : index} : index
    %28 = source {bb = 2 : ui32, name = #handshake.name<"source1">}
    %29 = constant %28 {bb = 2 : ui32, name = #handshake.name<"constant12">, value = 8 : index} : index
    %30 = source {bb = 2 : ui32, name = #handshake.name<"source2">}
    %31 = constant %30 {bb = 2 : ui32, name = #handshake.name<"constant13">, value = 1 : index} : index
    %addressResult, %dataResult = mc_load[%20] %memOutputs {bb = 2 : ui32, name = #handshake.name<"mc_load0">} : index, i32
    %32 = arith.shli %25, %27 {bb = 2 : ui32, name = #handshake.name<"shli0">} : index
    %33 = arith.addi %20, %32 {bb = 2 : ui32, name = #handshake.name<"addi3">} : index
    %addressResult_8, %dataResult_9 = mc_load[%33] %memOutputs_3 {bb = 2 : ui32, name = #handshake.name<"mc_load1">} : index, i32
    %34 = arith.muli %dataResult_9, %dataResult {bb = 2 : ui32, name = #handshake.name<"muli0">} : i32
    %35 = arith.shli %25, %27 {bb = 2 : ui32, name = #handshake.name<"shli1">} : index
    %36 = arith.addi %20, %35 {bb = 2 : ui32, name = #handshake.name<"addi4">} : index
    %addressResult_10, %dataResult_11 = mc_load[%36] %memOutputs_1 {bb = 2 : ui32, name = #handshake.name<"mc_load2">} : index, i32
    %37 = arith.muli %dataResult_11, %dataResult {bb = 2 : ui32, name = #handshake.name<"muli1">} : i32
    %38 = arith.addi %22, %34 {bb = 2 : ui32, name = #handshake.name<"addi0">} : i32
    %39 = arith.addi %21, %37 {bb = 2 : ui32, name = #handshake.name<"addi1">} : i32
    %40 = arith.addi %20, %31 {bb = 2 : ui32, name = #handshake.name<"addi5">} : index
    %41 = arith.cmpi ult, %40, %29 {bb = 2 : ui32, name = #handshake.name<"cmpi0">} : index
    %trueResult, %falseResult = cond_br %41, %40 {bb = 2 : ui32, name = #handshake.name<"cond_br2">} : index
    %trueResult_12, %falseResult_13 = cond_br %41, %39 {bb = 2 : ui32, name = #handshake.name<"cond_br3">} : i32
    %trueResult_14, %falseResult_15 = cond_br %41, %38 {bb = 2 : ui32, name = #handshake.name<"cond_br4">} : i32
    %trueResult_16, %falseResult_17 = cond_br %41, %23 {bb = 2 : ui32, name = #handshake.name<"cond_br5">} : i32
    %trueResult_18, %falseResult_19 = cond_br %41, %24 {bb = 2 : ui32, name = #handshake.name<"cond_br6">} : i32
    %trueResult_20, %falseResult_21 = cond_br %41, %25 {bb = 2 : ui32, name = #handshake.name<"cond_br7">} : index
    %trueResult_22, %falseResult_23 = cond_br %41, %result_6 {bb = 2 : ui32, name = #handshake.name<"cond_br8">} : none
    %trueResult_24, %falseResult_25 = cond_br %41, %23 {bb = 2 : ui32, name = #handshake.name<"cond_br9">} : i32
    %trueResult_26, %falseResult_27 = cond_br %41, %24 {bb = 2 : ui32, name = #handshake.name<"cond_br10">} : i32
    %trueResult_28, %falseResult_29 = cond_br %41, %25 {bb = 2 : ui32, name = #handshake.name<"cond_br11">} : index
    %trueResult_30, %falseResult_31 = cond_br %41, %38 {bb = 2 : ui32, name = #handshake.name<"cond_br12">} : i32
    %trueResult_32, %falseResult_33 = cond_br %41, %39 {bb = 2 : ui32, name = #handshake.name<"cond_br13">} : i32
    %trueResult_34, %falseResult_35 = cond_br %41, %result_6 {bb = 2 : ui32, name = #handshake.name<"cond_br14">} : none
    %42 = merge %falseResult_17 {bb = 3 : ui32, name = #handshake.name<"merge3">} : i32
    %43 = merge %falseResult_19 {bb = 3 : ui32, name = #handshake.name<"merge4">} : i32
    %44 = merge %falseResult_21 {bb = 3 : ui32, name = #handshake.name<"merge5">} : index
    %45 = merge %falseResult_15 {bb = 3 : ui32, name = #handshake.name<"merge6">} : i32
    %46 = merge %falseResult_13 {bb = 3 : ui32, name = #handshake.name<"merge7">} : i32
    %result_36, %index_37 = control_merge %falseResult_23 {bb = 3 : ui32, name = #handshake.name<"control_merge2">} : none, index
    %47 = constant %result_36 {bb = 3 : ui32, name = #handshake.name<"constant14">, value = 1 : i32} : i32
    %48 = constant %result_36 {bb = 3 : ui32, name = #handshake.name<"constant15">, value = 1 : i32} : i32
    %49 = source {bb = 3 : ui32, name = #handshake.name<"source3">}
    %50 = constant %49 {bb = 3 : ui32, name = #handshake.name<"constant16">, value = 8 : index} : index
    %51 = source {bb = 3 : ui32, name = #handshake.name<"source4">}
    %52 = constant %51 {bb = 3 : ui32, name = #handshake.name<"constant17">, value = 1 : index} : index
    %addressResult_38, %dataResult_39 = mc_store[%44] %45 {bb = 3 : ui32, name = #handshake.name<"mc_store0">} : i32, index
    %53 = arith.muli %42, %45 {bb = 3 : ui32, name = #handshake.name<"muli2">} : i32
    %54 = arith.muli %43, %46 {bb = 3 : ui32, name = #handshake.name<"muli3">} : i32
    %55 = arith.addi %53, %54 {bb = 3 : ui32, name = #handshake.name<"addi2">} : i32
    %addressResult_40, %dataResult_41 = mc_store[%44] %55 {bb = 3 : ui32, name = #handshake.name<"mc_store1">} : i32, index
    %56 = arith.addi %44, %52 {bb = 3 : ui32, name = #handshake.name<"addi6">} : index
    %57 = arith.cmpi ult, %56, %50 {bb = 3 : ui32, name = #handshake.name<"cmpi1">} : index
    %trueResult_42, %falseResult_43 = cond_br %57, %56 {bb = 3 : ui32, name = #handshake.name<"cond_br15">} : index
    %trueResult_44, %falseResult_45 = cond_br %57, %42 {bb = 3 : ui32, name = #handshake.name<"cond_br16">} : i32
    %trueResult_46, %falseResult_47 = cond_br %57, %43 {bb = 3 : ui32, name = #handshake.name<"cond_br17">} : i32
    %trueResult_48, %falseResult_49 = cond_br %57, %result_36 {bb = 3 : ui32, name = #handshake.name<"cond_br18">} : none
    %trueResult_50, %falseResult_51 = cond_br %57, %result_36 {bb = 3 : ui32, name = #handshake.name<"cond_br19">} : none
    %result_52, %index_53 = control_merge %falseResult_49 {bb = 4 : ui32, name = #handshake.name<"control_merge3">} : none, index
    %58 = d_return {bb = 4 : ui32, name = #handshake.name<"d_return0">} %result_52 : none
    end {bb = 4 : ui32, name = #handshake.name<"end0">} %58, %done, %done_0, %done_2, %done_4, %done_5 : none, none, none, none, none, none
  }
}

