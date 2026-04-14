module {
  func.func @gesummv(%arg0: i32 {hls.INTERFACE_LATENCY = 0 : i64}, %arg1: i32 {hls.INTERFACE_LATENCY = 0 : i64}, %arg2: memref<8xi32> {hls.INTERFACE_PORT = "tmp", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}, %arg3: memref<64xi32> {hls.INTERFACE_PORT = "A", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg4: memref<64xi32> {hls.INTERFACE_PORT = "B", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg5: memref<8xi32> {hls.INTERFACE_PORT = "X", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg6: memref<8xi32> {hls.INTERFACE_PORT = "Y", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}) attributes {argNames = ["alpha", "beta", "tmp", "A", "B", "X", "Y"], resultNames = []} {
    %c1 = arith.constant 1 : index
    %c8 = arith.constant 8 : index
    %c0 = arith.constant 0 : index
    %c0_i32 = arith.constant 0 : i32
    %c3 = arith.constant 3 : index
    cf.br ^bb1(%c0 : index) {name = #handshake.name<"br0">}
  ^bb1(%0: index):  // 2 preds: ^bb0, ^bb3
    cf.br ^bb2(%c0, %c0_i32, %c0_i32 : index, i32, i32) {name = #handshake.name<"br1">}
  ^bb2(%1: index, %2: i32, %3: i32):  // 2 preds: ^bb1, ^bb2
    %4 = memref.load %arg5[%1] {name = #handshake.name<"load3">} : memref<8xi32>
    %5 = arith.shli %0, %c3 {name = #handshake.name<"shli0">} : index
    %6 = arith.addi %1, %5 {name = #handshake.name<"addi3">} : index
    %7 = memref.load %arg3[%6] {name = #handshake.name<"load6">} : memref<64xi32>
    %8 = arith.muli %7, %4 {name = #handshake.name<"muli0">} : i32
    %9 = arith.shli %0, %c3 {name = #handshake.name<"shli1">} : index
    %10 = arith.addi %1, %9 {name = #handshake.name<"addi4">} : index
    %11 = memref.load %arg4[%10] {name = #handshake.name<"load7">} : memref<64xi32>
    %12 = arith.muli %11, %4 {name = #handshake.name<"muli1">} : i32
    %13 = arith.addi %3, %8 {name = #handshake.name<"addi0">} : i32
    %14 = arith.addi %2, %12 {name = #handshake.name<"addi1">} : i32
    %15 = arith.addi %1, %c1 {name = #handshake.name<"addi5">} : index
    %16 = arith.cmpi ult, %15, %c8 {name = #handshake.name<"cmpi0">} : index
    cf.cond_br %16, ^bb2(%15, %14, %13 : index, i32, i32), ^bb3 {name = #handshake.name<"cond_br0">}
  ^bb3:  // pred: ^bb2
    memref.store %13, %arg2[%0] {name = #handshake.name<"store2">} : memref<8xi32>
    %17 = arith.muli %arg0, %13 {name = #handshake.name<"muli2">} : i32
    %18 = arith.muli %arg1, %14 {name = #handshake.name<"muli3">} : i32
    %19 = arith.addi %17, %18 {name = #handshake.name<"addi2">} : i32
    memref.store %19, %arg6[%0] {name = #handshake.name<"store3">} : memref<8xi32>
    %20 = arith.addi %0, %c1 {name = #handshake.name<"addi6">} : index
    %21 = arith.cmpi ult, %20, %c8 {name = #handshake.name<"cmpi1">} : index
    cf.cond_br %21, ^bb1(%20 : index), ^bb4 {name = #handshake.name<"cond_br1">}
  ^bb4:  // pred: ^bb3
    return {name = #handshake.name<"return0">}
  }
}

