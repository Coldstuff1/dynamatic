func.func @stencil_2d(%arg0: memref<1024xi32> {hls.INTERFACE_PORT = "orig", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg1: memref<16xi32> {hls.INTERFACE_PORT = "filter", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg2: memref<1024xi32> {hls.INTERFACE_PORT = "sol", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}) attributes {argNames = ["orig", "filter", "sol"], llvm.linkage = #llvm.linkage<external>, resultNames = []} {
    %c0_i32 = arith.constant 0 : i32
    %0 = llvm.mlir.undef : i32
    %alloca = memref.alloca() : memref<i32>
    affine.store %0, %alloca[] : memref<i32>
    affine.for %arg3 = 0 to 28 {
      affine.store %c0_i32, %alloca[] : memref<i32>
      affine.for %arg4 = 0 to 3 {
        affine.for %arg5 = 0 to 3 {
          %2 = affine.load %alloca[] : memref<i32>
          %3 = affine.load %arg1[%arg5 + %arg4 * 3] : memref<16xi32>
          %4 = affine.load %arg0[%arg5 + %arg3 + %arg4 * 30] : memref<1024xi32>
          %5 = func.call @mul_i32(%3, %4) : (i32, i32) -> i32
          %6 = func.call @add_i32(%2, %5) : (i32, i32) -> i32
          affine.store %6, %alloca[] : memref<i32>
        } {hls.PIPELINE_II = 2 : i64}
      } {hls.PIPELINE_II = 6 : i64}
      %1 = affine.load %alloca[] : memref<i32>
      affine.store %1, %arg2[%arg3] : memref<1024xi32>
    } {hls.PIPELINE_II = 19 : i64}
    return
  }
  func.func private @add_i32(i32 {hls.INTERFACE_LATENCY = 0 : i64}, i32 {hls.INTERFACE_LATENCY = 0 : i64}) -> (i32 {hls.INTERFACE_LATENCY = 0 : i64}) attributes {argNames = ["a", "b"], llvm.linkage = #llvm.linkage<external>, resultNames = ["out"]}
  func.func private @mul_i32(i32 {hls.INTERFACE_LATENCY = 0 : i64}, i32 {hls.INTERFACE_LATENCY = 0 : i64}) -> (i32 {hls.INTERFACE_LATENCY = 1 : i64}) attributes {argNames = ["a", "b"], llvm.linkage = #llvm.linkage<external>, resultNames = ["out"]}
