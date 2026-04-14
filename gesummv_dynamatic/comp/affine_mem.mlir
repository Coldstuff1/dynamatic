module {
  func.func @gesummv(%arg0: i32 {hls.INTERFACE_LATENCY = 0 : i64}, %arg1: i32 {hls.INTERFACE_LATENCY = 0 : i64}, %arg2: memref<8xi32> {hls.INTERFACE_PORT = "tmp", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}, %arg3: memref<8x8xi32> {hls.INTERFACE_PORT = "A", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg4: memref<8x8xi32> {hls.INTERFACE_PORT = "B", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg5: memref<8xi32> {hls.INTERFACE_PORT = "X", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg6: memref<8xi32> {hls.INTERFACE_PORT = "Y", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}) attributes {argNames = ["alpha", "beta", "tmp", "A", "B", "X", "Y"], resultNames = []} {
    %c0_i32 = arith.constant {name = #handshake.name<"constant0">} 0 : i32
    affine.for %arg7 = 0 to 8 {
      %0:2 = affine.for %arg8 = 0 to 8 iter_args(%arg9 = %c0_i32, %arg10 = %c0_i32) -> (i32, i32) {
        %4 = affine.load %arg5[%arg8] {name = #handshake.name<"load0">} : memref<8xi32>
        %5 = affine.load %arg3[%arg7, %arg8] {name = #handshake.name<"load1">} : memref<8x8xi32>
        %6 = arith.muli %5, %4 {name = #handshake.name<"muli0">} : i32
        %7 = affine.load %arg4[%arg7, %arg8] {name = #handshake.name<"load2">} : memref<8x8xi32>
        %8 = arith.muli %7, %4 {name = #handshake.name<"muli1">} : i32
        %9 = arith.addi %arg10, %6 {name = #handshake.name<"addi0">} : i32
        %10 = arith.addi %arg9, %8 {name = #handshake.name<"addi1">} : i32
        affine.yield {name = #handshake.name<"yield0">} %10, %9 : i32, i32
      } {name = #handshake.name<"for0">}
      affine.store %0#1, %arg2[%arg7] {name = #handshake.name<"store0">} : memref<8xi32>
      %1 = arith.muli %arg0, %0#1 {name = #handshake.name<"muli2">} : i32
      %2 = arith.muli %arg1, %0#0 {name = #handshake.name<"muli3">} : i32
      %3 = arith.addi %1, %2 {name = #handshake.name<"addi2">} : i32
      affine.store %3, %arg6[%arg7] {name = #handshake.name<"store1">} : memref<8xi32>
    } {name = #handshake.name<"for1">}
    return {name = #handshake.name<"return0">}
  }
}

