func.func @vector_rescale(%arg0: memref<1024xi32> {hls.INTERFACE_PORT = "a", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg1: i32 {hls.INTERFACE_LATENCY = 0 : i64}, %arg2: memref<1024xi32> {hls.INTERFACE_PORT = "b", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}) attributes {argNames = ["a", "c", "b"], llvm.linkage = #llvm.linkage<external>, resultNames = []} {
    affine.for %arg3 = 0 to 1024 {
      %0 = affine.load %arg0[%arg3] : memref<1024xi32>
      %1 = func.call @mul_i32(%0, %arg1) : (i32, i32) -> i32
      affine.store %1, %arg2[%arg3] : memref<1024xi32>
    } {hls.PIPELINE_II = 3 : i64}
    return
  }
  func.func private @mul_i32(i32 {hls.INTERFACE_PORT = "a", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, i32 {hls.INTERFACE_PORT = "b", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}) -> (i32 {hls.INTERFACE_LATENCY = 1 : i64}) attributes {argNames = ["a", "b"], llvm.linkage = #llvm.linkage<external>, resultNames = ["out"]}
