module {
  handshake.func @gesummv(%arg0: i32 {hls.INTERFACE_LATENCY = 0 : i64}, %arg1: i32 {hls.INTERFACE_LATENCY = 0 : i64}, %arg2: memref<8xi32> {hls.INTERFACE_PORT = "tmp", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}, %arg3: memref<64xi32> {hls.INTERFACE_PORT = "A", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg4: memref<64xi32> {hls.INTERFACE_PORT = "B", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg5: memref<8xi32> {hls.INTERFACE_PORT = "X", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg6: memref<8xi32> {hls.INTERFACE_PORT = "Y", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}, %arg7: none, ...) -> none attributes {argNames = ["alpha", "beta", "tmp", "A", "B", "X", "Y", "start"], resNames = ["out0"], resultNames = []} {
    %done = mem_controller[%arg6 : memref<8xi32>] (%104#1, %addressResult_26, %dataResult_27) {bufProps = #handshake<bufProps{"0": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00, "1": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00, "2": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00, "3": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00}>, connectedBlocks = [3 : i32], name = #handshake.name<"mem_controller0">} : (i32, i32, i32) -> none
    %memOutputs, %done_0 = mem_controller[%arg5 : memref<8xi32>] (%addressResult) {bufProps = #handshake<bufProps{"0": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00, "1": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00}>, connectedBlocks = [2 : i32], name = #handshake.name<"mem_controller1">} : (i32) -> (i32, none)
    %memOutputs_1, %done_2 = mem_controller[%arg4 : memref<64xi32>] (%addressResult_10) {bufProps = #handshake<bufProps{"0": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00, "1": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00}>, connectedBlocks = [2 : i32], name = #handshake.name<"mem_controller2">} : (i32) -> (i32, none)
    %memOutputs_3, %done_4 = mem_controller[%arg3 : memref<64xi32>] (%addressResult_8) {bufProps = #handshake<bufProps{"0": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00, "1": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00}>, connectedBlocks = [2 : i32], name = #handshake.name<"mem_controller3">} : (i32) -> (i32, none)
    %done_5 = mem_controller[%arg2 : memref<8xi32>] (%104#0, %addressResult_24, %dataResult_25) {bufProps = #handshake<bufProps{"0": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00, "1": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00, "2": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00, "3": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00}>, connectedBlocks = [3 : i32], name = #handshake.name<"mem_controller4">} : (i32, i32, i32) -> none
    %0 = buffer [1] seq %arg7 {bb = 0 : ui32, name = #handshake.name<"buffer4">} : none
    %1 = buffer [1] fifo %0 {bb = 0 : ui32, name = #handshake.name<"buffer5">} : none
    %2:2 = fork [2] %1 {bb = 0 : ui32, name = #handshake.name<"fork0">} : none
    %3 = constant %2#1 {bb = 0 : ui32, name = #handshake.name<"constant0">, value = false} : i1
    %4 = arith.extsi %3 {bb = 0 : ui32, name = #handshake.name<"extsi8">} : i1 to i4
    %5 = buffer [1] seq %arg0 {bb = 0 : ui32, name = #handshake.name<"buffer0">} : i32
    %6 = buffer [1] fifo %5 {bb = 0 : ui32, name = #handshake.name<"buffer1">} : i32
    %7 = buffer [1] seq %arg1 {bb = 0 : ui32, name = #handshake.name<"buffer2">} : i32
    %8 = buffer [1] fifo %7 {bb = 0 : ui32, name = #handshake.name<"buffer3">} : i32
    %9 = mux %12#0 [%trueResult_28, %4] {bb = 1 : ui32, name = #handshake.name<"mux9">} : i1, i4
    %10 = mux %12#2 [%trueResult_30, %6] {bb = 1 : ui32, name = #handshake.name<"mux1">} : i1, i32
    %11 = mux %12#1 [%trueResult_32, %8] {bb = 1 : ui32, name = #handshake.name<"mux2">} : i1, i32
    %result, %index = control_merge %trueResult_34, %2#0 {bb = 1 : ui32, name = #handshake.name<"control_merge4">} : none, i1
    %12:3 = fork [3] %index {bb = 1 : ui32, name = #handshake.name<"fork1">} : i1
    %13 = buffer [1] seq %result {bb = 1 : ui32, name = #handshake.name<"buffer12">} : none
    %14 = buffer [1] fifo %13 {bb = 1 : ui32, name = #handshake.name<"buffer13">} : none
    %15:2 = fork [2] %14 {bb = 1 : ui32, name = #handshake.name<"fork2">} : none
    %16 = constant %15#0 {bb = 1 : ui32, name = #handshake.name<"constant1">, value = false} : i1
    %17:3 = fork [3] %16 {bb = 1 : ui32, name = #handshake.name<"fork3">} : i1
    %18 = arith.extsi %17#0 {bb = 1 : ui32, name = #handshake.name<"extsi9">} : i1 to i4
    %19 = arith.extsi %17#1 {bb = 1 : ui32, name = #handshake.name<"extsi10">} : i1 to i32
    %20 = arith.extsi %17#2 {bb = 1 : ui32, name = #handshake.name<"extsi11">} : i1 to i32
    %21 = buffer [1] seq %10 {bb = 1 : ui32, name = #handshake.name<"buffer8">} : i32
    %22 = buffer [1] fifo %21 {bb = 1 : ui32, name = #handshake.name<"buffer9">} : i32
    %23 = buffer [1] seq %11 {bb = 1 : ui32, name = #handshake.name<"buffer10">} : i32
    %24 = buffer [1] fifo %23 {bb = 1 : ui32, name = #handshake.name<"buffer11">} : i32
    %25 = buffer [1] seq %9 {bb = 1 : ui32, name = #handshake.name<"buffer6">} : i4
    %26 = buffer [1] fifo %25 {bb = 1 : ui32, name = #handshake.name<"buffer7">} : i4
    %27 = mux %45#1 [%trueResult, %18] {bb = 2 : ui32, name = #handshake.name<"mux10">} : i1, i4
    %28 = buffer [1] seq %27 {bb = 2 : ui32, name = #handshake.name<"buffer14">} : i4
    %29 = buffer [1] fifo %28 {bb = 2 : ui32, name = #handshake.name<"buffer15">} : i4
    %30:4 = fork [4] %29 {bb = 2 : ui32, name = #handshake.name<"fork4">} : i4
    %31 = arith.extsi %30#0 {bb = 2 : ui32, name = #handshake.name<"extsi12">} : i4 to i8
    %32 = arith.extsi %30#1 {bb = 2 : ui32, name = #handshake.name<"extsi13">} : i4 to i8
    %33 = arith.extsi %30#2 {bb = 2 : ui32, name = #handshake.name<"extsi14">} : i4 to i5
    %34 = arith.extsi %30#3 {bb = 2 : ui32, name = #handshake.name<"extsi15">} : i4 to i32
    %35 = mux %45#5 [%trueResult_12, %20] {bb = 2 : ui32, name = #handshake.name<"mux4">} : i1, i32
    %36 = mux %45#4 [%trueResult_14, %19] {bb = 2 : ui32, name = #handshake.name<"mux5">} : i1, i32
    %37 = mux %45#3 [%trueResult_16, %22] {bb = 2 : ui32, name = #handshake.name<"mux6">} : i1, i32
    %38 = mux %45#2 [%trueResult_18, %24] {bb = 2 : ui32, name = #handshake.name<"mux7">} : i1, i32
    %39 = mux %45#0 [%trueResult_20, %26] {bb = 2 : ui32, name = #handshake.name<"mux11">} : i1, i4
    %40 = buffer [1] seq %39 {bb = 2 : ui32, name = #handshake.name<"buffer24">} : i4
    %41 = buffer [1] fifo %40 {bb = 2 : ui32, name = #handshake.name<"buffer25">} : i4
    %42:3 = fork [3] %41 {bb = 2 : ui32, name = #handshake.name<"fork5">} : i4
    %43 = arith.extsi %42#1 {bb = 2 : ui32, name = #handshake.name<"extsi16">} : i4 to i7
    %44 = arith.extsi %42#2 {bb = 2 : ui32, name = #handshake.name<"extsi17">} : i4 to i7
    %result_6, %index_7 = control_merge %trueResult_22, %15#1 {bb = 2 : ui32, name = #handshake.name<"control_merge5">} : none, i1
    %45:6 = fork [6] %index_7 {bb = 2 : ui32, name = #handshake.name<"fork6">} : i1
    %46 = source {bb = 2 : ui32, name = #handshake.name<"source0">}
    %47 = constant %46 {bb = 2 : ui32, name = #handshake.name<"constant4">, value = 3 : i3} : i3
    %48:2 = fork [2] %47 {bb = 2 : ui32, name = #handshake.name<"fork7">} : i3
    %49 = arith.extui %48#0 {bb = 2 : ui32, name = #handshake.name<"extui0">} : i3 to i7
    %50 = arith.extui %48#1 {bb = 2 : ui32, name = #handshake.name<"extui1">} : i3 to i7
    %51 = source {bb = 2 : ui32, name = #handshake.name<"source1">}
    %52 = constant %51 {bb = 2 : ui32, name = #handshake.name<"constant12">, value = 8 : i5} : i5
    %53 = source {bb = 2 : ui32, name = #handshake.name<"source2">}
    %54 = constant %53 {bb = 2 : ui32, name = #handshake.name<"constant13">, value = 1 : i2} : i2
    %55 = arith.extsi %54 {bb = 2 : ui32, name = #handshake.name<"extsi18">} : i2 to i5
    %addressResult, %dataResult = mc_load[%34] %memOutputs {bb = 2 : ui32, bufProps = #handshake<bufProps{"1": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00}>, name = #handshake.name<"mc_load0">} : i32, i32
    %56:2 = fork [2] %dataResult {bb = 2 : ui32, name = #handshake.name<"fork8">} : i32
    %57 = arith.shli %44, %50 {bb = 2 : ui32, name = #handshake.name<"shli2">} : i7
    %58 = arith.extsi %57 {bb = 2 : ui32, name = #handshake.name<"extsi19">} : i7 to i8
    %59 = arith.addi %32, %58 {bb = 2 : ui32, name = #handshake.name<"addi7">} : i8
    %60 = arith.extsi %59 {bb = 2 : ui32, name = #handshake.name<"extsi20">} : i8 to i32
    %addressResult_8, %dataResult_9 = mc_load[%60] %memOutputs_3 {bb = 2 : ui32, bufProps = #handshake<bufProps{"1": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00}>, name = #handshake.name<"mc_load1">} : i32, i32
    %61 = arith.muli %dataResult_9, %56#1 {bb = 2 : ui32, name = #handshake.name<"muli0">} : i32
    %62 = arith.shli %43, %49 {bb = 2 : ui32, name = #handshake.name<"shli3">} : i7
    %63 = arith.extsi %62 {bb = 2 : ui32, name = #handshake.name<"extsi21">} : i7 to i8
    %64 = arith.addi %31, %63 {bb = 2 : ui32, name = #handshake.name<"addi8">} : i8
    %65 = arith.extsi %64 {bb = 2 : ui32, name = #handshake.name<"extsi22">} : i8 to i32
    %addressResult_10, %dataResult_11 = mc_load[%65] %memOutputs_1 {bb = 2 : ui32, bufProps = #handshake<bufProps{"1": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00}>, name = #handshake.name<"mc_load2">} : i32, i32
    %66 = arith.muli %dataResult_11, %56#0 {bb = 2 : ui32, name = #handshake.name<"muli1">} : i32
    %67 = buffer [1] seq %36 {bb = 2 : ui32, name = #handshake.name<"buffer18">} : i32
    %68 = buffer [1] fifo %67 {bb = 2 : ui32, name = #handshake.name<"buffer19">} : i32
    %69 = arith.addi %68, %61 {bb = 2 : ui32, name = #handshake.name<"addi0">} : i32
    %70 = buffer [1] seq %35 {bb = 2 : ui32, name = #handshake.name<"buffer16">} : i32
    %71 = buffer [1] fifo %70 {bb = 2 : ui32, name = #handshake.name<"buffer17">} : i32
    %72 = arith.addi %71, %66 {bb = 2 : ui32, name = #handshake.name<"addi1">} : i32
    %73 = arith.addi %33, %55 {bb = 2 : ui32, name = #handshake.name<"addi9">} : i5
    %74:2 = fork [2] %73 {bb = 2 : ui32, name = #handshake.name<"fork9">} : i5
    %75 = arith.trunci %74#0 {bb = 2 : ui32, name = #handshake.name<"trunci0">} : i5 to i4
    %76 = arith.cmpi ult, %74#1, %52 {bb = 2 : ui32, name = #handshake.name<"cmpi2">} : i5
    %77:7 = fork [7] %76 {bb = 2 : ui32, name = #handshake.name<"fork10">} : i1
    %trueResult, %falseResult = cond_br %77#0, %75 {bb = 2 : ui32, name = #handshake.name<"cond_br0">} : i4
    sink %falseResult {name = #handshake.name<"sink0">} : i4
    %trueResult_12, %falseResult_13 = cond_br %77#2, %72 {bb = 2 : ui32, name = #handshake.name<"cond_br3">} : i32
    %trueResult_14, %falseResult_15 = cond_br %77#3, %69 {bb = 2 : ui32, name = #handshake.name<"cond_br4">} : i32
    %78 = buffer [1] seq %37 {bb = 2 : ui32, name = #handshake.name<"buffer20">} : i32
    %79 = buffer [1] fifo %78 {bb = 2 : ui32, name = #handshake.name<"buffer21">} : i32
    %trueResult_16, %falseResult_17 = cond_br %77#4, %79 {bb = 2 : ui32, name = #handshake.name<"cond_br5">} : i32
    %80 = buffer [1] seq %38 {bb = 2 : ui32, name = #handshake.name<"buffer22">} : i32
    %81 = buffer [1] fifo %80 {bb = 2 : ui32, name = #handshake.name<"buffer23">} : i32
    %trueResult_18, %falseResult_19 = cond_br %77#5, %81 {bb = 2 : ui32, name = #handshake.name<"cond_br6">} : i32
    %trueResult_20, %falseResult_21 = cond_br %77#1, %42#0 {bb = 2 : ui32, name = #handshake.name<"cond_br1">} : i4
    %82 = buffer [1] seq %result_6 {bb = 2 : ui32, name = #handshake.name<"buffer26">} : none
    %83 = buffer [1] fifo %82 {bb = 2 : ui32, name = #handshake.name<"buffer27">} : none
    %trueResult_22, %falseResult_23 = cond_br %77#6, %83 {bb = 2 : ui32, name = #handshake.name<"cond_br8">} : none
    %84 = buffer [1] seq %falseResult_17 {bb = 3 : ui32, name = #handshake.name<"buffer28">} : i32
    %85 = buffer [1] fifo %84 {bb = 3 : ui32, name = #handshake.name<"buffer29">} : i32
    %86:2 = fork [2] %85 {bb = 3 : ui32, name = #handshake.name<"fork11">} : i32
    %87 = buffer [1] seq %falseResult_19 {bb = 3 : ui32, name = #handshake.name<"buffer30">} : i32
    %88 = buffer [1] fifo %87 {bb = 3 : ui32, name = #handshake.name<"buffer31">} : i32
    %89:2 = fork [2] %88 {bb = 3 : ui32, name = #handshake.name<"fork12">} : i32
    %90 = buffer [1] seq %falseResult_21 {bb = 3 : ui32, name = #handshake.name<"buffer32">} : i4
    %91 = buffer [1] fifo %90 {bb = 3 : ui32, name = #handshake.name<"buffer33">} : i4
    %92:2 = fork [2] %91 {bb = 3 : ui32, name = #handshake.name<"fork13">} : i4
    %93 = arith.extsi %92#0 {bb = 3 : ui32, name = #handshake.name<"extsi23">} : i4 to i5
    %94 = arith.extsi %92#1 {bb = 3 : ui32, name = #handshake.name<"extsi24">} : i4 to i32
    %95:2 = fork [2] %94 {bb = 3 : ui32, name = #handshake.name<"fork14">} : i32
    %96 = buffer [1] seq %falseResult_15 {bb = 3 : ui32, name = #handshake.name<"buffer34">} : i32
    %97 = buffer [1] fifo %96 {bb = 3 : ui32, name = #handshake.name<"buffer35">} : i32
    %98:2 = fork [2] %97 {bb = 3 : ui32, name = #handshake.name<"fork15">} : i32
    %99 = buffer [1] seq %falseResult_23 {bb = 3 : ui32, name = #handshake.name<"buffer38">} : none
    %100 = buffer [1] fifo %99 {bb = 3 : ui32, name = #handshake.name<"buffer39">} : none
    %101:2 = fork [2] %100 {bb = 3 : ui32, name = #handshake.name<"fork16">} : none
    %102 = constant %101#1 {bb = 3 : ui32, name = #handshake.name<"constant14">, value = 1 : i2} : i2
    %103 = arith.extsi %102 {bb = 3 : ui32, name = #handshake.name<"extsi5">} : i2 to i32
    %104:2 = fork [2] %103 {bb = 3 : ui32, name = #handshake.name<"fork17">} : i32
    %105 = source {bb = 3 : ui32, name = #handshake.name<"source3">}
    %106 = constant %105 {bb = 3 : ui32, name = #handshake.name<"constant16">, value = 8 : i5} : i5
    %107 = source {bb = 3 : ui32, name = #handshake.name<"source4">}
    %108 = constant %107 {bb = 3 : ui32, name = #handshake.name<"constant17">, value = 1 : i2} : i2
    %109 = arith.extsi %108 {bb = 3 : ui32, name = #handshake.name<"extsi25">} : i2 to i5
    %addressResult_24, %dataResult_25 = mc_store[%95#0] %98#1 {bb = 3 : ui32, name = #handshake.name<"mc_store0">} : i32, i32
    %110 = arith.muli %86#1, %98#0 {bb = 3 : ui32, name = #handshake.name<"muli2">} : i32
    %111 = buffer [1] seq %falseResult_13 {bb = 3 : ui32, name = #handshake.name<"buffer36">} : i32
    %112 = buffer [1] fifo %111 {bb = 3 : ui32, name = #handshake.name<"buffer37">} : i32
    %113 = arith.muli %89#1, %112 {bb = 3 : ui32, name = #handshake.name<"muli3">} : i32
    %114 = arith.addi %110, %113 {bb = 3 : ui32, name = #handshake.name<"addi2">} : i32
    %addressResult_26, %dataResult_27 = mc_store[%95#1] %114 {bb = 3 : ui32, name = #handshake.name<"mc_store1">} : i32, i32
    %115 = arith.addi %93, %109 {bb = 3 : ui32, name = #handshake.name<"addi10">} : i5
    %116:2 = fork [2] %115 {bb = 3 : ui32, name = #handshake.name<"fork18">} : i5
    %117 = arith.trunci %116#0 {bb = 3 : ui32, name = #handshake.name<"trunci1">} : i5 to i4
    %118 = arith.cmpi ult, %116#1, %106 {bb = 3 : ui32, name = #handshake.name<"cmpi3">} : i5
    %119:4 = fork [4] %118 {bb = 3 : ui32, name = #handshake.name<"fork19">} : i1
    %trueResult_28, %falseResult_29 = cond_br %119#0, %117 {bb = 3 : ui32, name = #handshake.name<"cond_br20">} : i4
    sink %falseResult_29 {name = #handshake.name<"sink1">} : i4
    %trueResult_30, %falseResult_31 = cond_br %119#1, %86#0 {bb = 3 : ui32, name = #handshake.name<"cond_br16">} : i32
    sink %falseResult_31 {name = #handshake.name<"sink2">} : i32
    %trueResult_32, %falseResult_33 = cond_br %119#2, %89#0 {bb = 3 : ui32, name = #handshake.name<"cond_br17">} : i32
    sink %falseResult_33 {name = #handshake.name<"sink3">} : i32
    %trueResult_34, %falseResult_35 = cond_br %119#3, %101#0 {bb = 3 : ui32, name = #handshake.name<"cond_br18">} : none
    %120 = buffer [1] seq %falseResult_35 {bb = 4 : ui32, name = #handshake.name<"buffer40">} : none
    %121 = buffer [1] fifo %120 {bb = 4 : ui32, name = #handshake.name<"buffer41">} : none
    %122 = d_return {bb = 4 : ui32, name = #handshake.name<"d_return0">} %121 : none
    end {bb = 4 : ui32, bufProps = #handshake<bufProps{"1": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00, "2": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00, "3": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00, "4": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00, "5": [0,0], [0,0], 0.000000e+00, 0.000000e+00, 0.000000e+00}>, name = #handshake.name<"end0">} %122, %done, %done_0, %done_2, %done_4, %done_5 : none, none, none, none, none, none
  }
}

