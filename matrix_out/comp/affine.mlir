  func.func @matrix(%arg0: memref<32x32xi32> {hls.INTERFACE_PORT = "inA", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg1: memref<32x32xi32> {hls.INTERFACE_PORT = "inB", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg2: memref<32x32xi32> {hls.INTERFACE_PORT = "outC", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}) attributes {argNames = ["inA", "inB", "outC"], llvm.linkage = #llvm.linkage<external>, resultNames = []} {
    %c0_i32 = arith.constant 0 : i32
    %0 = llvm.mlir.undef : i32
    %alloca = memref.alloca() : memref<i32>
    affine.store %0, %alloca[] : memref<i32>
    affine.for %arg3 = 0 to 32 {
      affine.for %arg4 = 0 to 32 {
        affine.store %c0_i32, %alloca[] : memref<i32>
        affine.for %arg5 = 0 to 32 {
          %2 = affine.load %alloca[] : memref<i32>
          %3 = affine.load %arg0[%arg3, %arg5] : memref<32x32xi32>
          %4 = affine.load %arg1[%arg5, %arg4] : memref<32x32xi32>
          %5 = func.call @mul_i32(%3, %4) : (i32, i32) -> i32
          %6 = func.call @add_i32(%2, %5) : (i32, i32) -> i32
          affine.store %6, %alloca[] : memref<i32>
        } {hls.PIPELINE_II = 2 : i64}
        %1 = affine.load %alloca[] : memref<i32>
        affine.store %1, %arg2[%arg3, %arg4] : memref<32x32xi32>
      } {hls.PIPELINE_II = 65 : i64}
    } {hls.PIPELINE_II = 2080 : i64}
    return
  }
  func.func private @add_i32(i32 {hls.INTERFACE_LATENCY = 0 : i64}, i32 {hls.INTERFACE_LATENCY = 0 : i64}) -> (i32 {hls.INTERFACE_LATENCY = 0 : i64}) attributes {argNames = ["a", "b"], llvm.linkage = #llvm.linkage<external>, resultNames = ["out"]}
  func.func private @mul_i32(i32 {hls.INTERFACE_LATENCY = 0 : i64}, i32 {hls.INTERFACE_LATENCY = 0 : i64}) -> (i32 {hls.INTERFACE_LATENCY = 1 : i64}) attributes {argNames = ["a", "b"], llvm.linkage = #llvm.linkage<external>, resultNames = ["out"]}
