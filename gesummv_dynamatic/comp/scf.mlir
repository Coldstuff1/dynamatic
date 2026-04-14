module {
  func.func @gesummv(%arg0: i32 {hls.INTERFACE_LATENCY = 0 : i64}, %arg1: i32 {hls.INTERFACE_LATENCY = 0 : i64}, %arg2: memref<8xi32> {hls.INTERFACE_PORT = "tmp", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}, %arg3: memref<64xi32> {hls.INTERFACE_PORT = "A", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg4: memref<64xi32> {hls.INTERFACE_PORT = "B", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg5: memref<8xi32> {hls.INTERFACE_PORT = "X", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg6: memref<8xi32> {hls.INTERFACE_PORT = "Y", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}) attributes {argNames = ["alpha", "beta", "tmp", "A", "B", "X", "Y"], resultNames = []} {
    %c3 = arith.constant {name = #handshake.name<"constant7">} 3 : index
    %c0_i32 = arith.constant {name = #handshake.name<"constant0">} 0 : i32
    %c0 = arith.constant {name = #handshake.name<"constant1">} 0 : index
    %c8 = arith.constant {name = #handshake.name<"constant2">} 8 : index
    %c1 = arith.constant {name = #handshake.name<"constant3">} 1 : index
    %0 = scf.while (%arg7 = %c0) : (index) -> index {
      %1:3 = scf.while (%arg8 = %c0, %arg9 = %c0_i32, %arg10 = %c0_i32) : (index, i32, i32) -> (index, i32, i32) {
        %7 = memref.load %arg5[%arg8] {name = #handshake.name<"load3">} : memref<8xi32>
        %8 = arith.shli %arg7, %c3 {name = #handshake.name<"shli0">} : index
        %9 = arith.addi %arg8, %8 {name = #handshake.name<"addi3">} : index
        %10 = memref.load %arg3[%9] {name = #handshake.name<"load6">} : memref<64xi32>
        %11 = arith.muli %10, %7 {name = #handshake.name<"muli0">} : i32
        %12 = arith.shli %arg7, %c3 {name = #handshake.name<"shli1">} : index
        %13 = arith.addi %arg8, %12 {name = #handshake.name<"addi4">} : index
        %14 = memref.load %arg4[%13] {name = #handshake.name<"load7">} : memref<64xi32>
        %15 = arith.muli %14, %7 {name = #handshake.name<"muli1">} : i32
        %16 = arith.addi %arg10, %11 {name = #handshake.name<"addi0">} : i32
        %17 = arith.addi %arg9, %15 {name = #handshake.name<"addi1">} : i32
        %18 = arith.addi %arg8, %c1 {name = #handshake.name<"addi5">} : index
        %19 = arith.cmpi ult, %18, %c8 {name = #handshake.name<"cmpi0">} : index
        scf.condition(%19) {name = #handshake.name<"condition0">} %18, %17, %16 : index, i32, i32
      } do {
      ^bb0(%arg8: index, %arg9: i32, %arg10: i32):
        scf.yield {name = #handshake.name<"yield3">} %arg8, %arg9, %arg10 : index, i32, i32
      } attributes {name = #handshake.name<"while0">}
      memref.store %1#2, %arg2[%arg7] {name = #handshake.name<"store2">} : memref<8xi32>
      %2 = arith.muli %arg0, %1#2 {name = #handshake.name<"muli2">} : i32
      %3 = arith.muli %arg1, %1#1 {name = #handshake.name<"muli3">} : i32
      %4 = arith.addi %2, %3 {name = #handshake.name<"addi2">} : i32
      memref.store %4, %arg6[%arg7] {name = #handshake.name<"store3">} : memref<8xi32>
      %5 = arith.addi %arg7, %c1 {name = #handshake.name<"addi6">} : index
      %6 = arith.cmpi ult, %5, %c8 {name = #handshake.name<"cmpi1">} : index
      scf.condition(%6) {name = #handshake.name<"condition1">} %5 : index
    } do {
    ^bb0(%arg7: index):
      scf.yield {name = #handshake.name<"yield4">} %arg7 : index
    } attributes {name = #handshake.name<"while1">}
    return {name = #handshake.name<"return0">}
  }
}

