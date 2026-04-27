#map = affine_map<(d0) -> (-d0 + 128)>
#map1 = affine_map<(d0) -> (d0 + 1)>
  func.func @polyn_mult(%arg0: memref<128xi32> {hls.INTERFACE_PORT = "a", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg1: memref<128xi32> {hls.INTERFACE_PORT = "b", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg2: memref<128xi32> {hls.INTERFACE_PORT = "out", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}) attributes {argNames = ["a", "b", "out"], llvm.linkage = #llvm.linkage<external>, resultNames = []} {
    %c0_i32 = arith.constant 0 : i32
    %alloca = memref.alloca() : memref<i32>
    %0 = llvm.mlir.undef : i32
    affine.store %0, %alloca[] : memref<i32>
    affine.for %arg3 = 0 to 128 {
      %1 = arith.index_cast %arg3 : index to i32
      affine.store %c0_i32, %arg2[%arg3] : memref<128xi32>
      affine.store %c0_i32, %alloca[] : memref<i32>
      affine.for %arg4 = 1 to #map(%arg3) {
        %4 = arith.index_cast %arg4 : index to i32
        affine.store %4, %alloca[] : memref<i32>
        %5 = affine.load %arg2[%arg3] : memref<128xi32>
        %6 = affine.load %arg0[%arg3 + %arg4] : memref<128xi32>
        %7 = affine.load %arg1[-%arg4 + 128] : memref<128xi32>
        %8 = func.call @mul_i32(%6, %7) : (i32, i32) -> i32
        %9 = func.call @add_i32(%5, %8) : (i32, i32) -> i32
        affine.store %9, %arg2[%arg3] : memref<128xi32>
      } {hls.PIPELINE_II = 3 : i64}
      affine.for %arg4 = 0 to #map1(%arg3) {
        %4 = arith.index_cast %arg4 : index to i32
        affine.store %4, %alloca[] : memref<i32>
        %5 = affine.load %arg2[%arg3] : memref<128xi32>
        %6 = affine.load %arg0[%arg3 - %arg4] : memref<128xi32>
        %7 = affine.load %arg1[%arg4] : memref<128xi32>
        %8 = func.call @mul_i32(%6, %7) : (i32, i32) -> i32
        %9 = func.call @add_i32(%5, %8) : (i32, i32) -> i32
        affine.store %9, %arg2[%arg3] : memref<128xi32>
      } {hls.PIPELINE_II = 3 : i64}
      %2 = affine.load %alloca[] : memref<i32>
      %3 = func.call @add_i32(%2, %1) : (i32, i32) -> i32
    } {hls.PIPELINE_II = 385 : i64}
    return
  }
  func.func private @add_i32(i32 {hls.INTERFACE_PORT = "a", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, i32 {hls.INTERFACE_PORT = "b", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}) -> (i32 {hls.INTERFACE_LATENCY = 0 : i64}) attributes {argNames = ["a", "b"], llvm.linkage = #llvm.linkage<external>, resultNames = ["out"]}
  func.func private @mul_i32(i32 {hls.INTERFACE_PORT = "a", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, i32 {hls.INTERFACE_PORT = "b", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}) -> (i32 {hls.INTERFACE_LATENCY = 1 : i64}) attributes {argNames = ["a", "b"], llvm.linkage = #llvm.linkage<external>, resultNames = ["out"]}
