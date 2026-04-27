#map = affine_map<(d0) -> (d0 * 2)>
  func.func @gaussian(%arg0: memref<16xi32> {hls.INTERFACE_PORT = "c", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg1: memref<16x16xi32> {hls.INTERFACE_PORT = "a", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}) attributes {argNames = ["c", "a"], llvm.linkage = #llvm.linkage<external>, resultNames = []} {
    %c0_i32 = arith.constant 0 : i32
    %alloca = memref.alloca() : memref<i32>
    affine.store %c0_i32, %alloca[] : memref<i32>
    affine.for %arg2 = 1 to 15 {
      affine.for %arg3 = #map(%arg2) to 15 {
        affine.for %arg4 = 1 to 16 {
          %0 = arith.index_cast %arg4 : index to i32
          %1 = affine.load %arg1[%arg3, %arg4] : memref<16x16xi32>
          %2 = affine.load %arg0[%arg2] : memref<16xi32>
          %3 = affine.load %arg1[%arg2, %arg4] : memref<16x16xi32>
          %4 = func.call @mul_i32(%2, %3) : (i32, i32) -> i32
          %5 = func.call @sub_i32(%1, %4) : (i32, i32) -> i32
          affine.store %5, %arg1[%arg3, %arg4] : memref<16x16xi32>
          %6 = affine.load %alloca[] : memref<i32>
          %7 = func.call @add_i32(%6, %0) : (i32, i32) -> i32
          affine.store %7, %alloca[] : memref<i32>
        } {hls.PIPELINE_II = 3 : i64}
      } {hls.PIPELINE_II = 45 : i64}
    } {hls.PIPELINE_II = 585 : i64}
    return
  }
  func.func private @sub_i32(i32 {hls.INTERFACE_PORT = "a", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}, i32 {hls.INTERFACE_LATENCY = 0 : i64}) -> (i32 {hls.INTERFACE_LATENCY = 0 : i64}) attributes {argNames = ["a", "b"], llvm.linkage = #llvm.linkage<external>, resultNames = ["out"]}
  func.func private @mul_i32(i32 {hls.INTERFACE_PORT = "a", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}, i32 {hls.INTERFACE_LATENCY = 0 : i64}) -> (i32 {hls.INTERFACE_LATENCY = 1 : i64}) attributes {argNames = ["a", "b"], llvm.linkage = #llvm.linkage<external>, resultNames = ["out"]}
  func.func private @add_i32(i32 {hls.INTERFACE_PORT = "a", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}, i32 {hls.INTERFACE_LATENCY = 0 : i64}) -> (i32 {hls.INTERFACE_LATENCY = 0 : i64}) attributes {argNames = ["a", "b"], llvm.linkage = #llvm.linkage<external>, resultNames = ["out"]}
