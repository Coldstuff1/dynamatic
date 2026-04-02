module {
  func.func @gesummv_hir(%arg0: i32 {hir.delay = 0 : i64, hls.INTERFACE_LATENCY = 0 : i64}, %arg1: i32 {hir.delay = 0 : i64, hls.INTERFACE_LATENCY = 0 : i64}, %arg2: memref<8xi32> {hir.memref.ports = [{wr_latency = 1 : i64}], hls.INTERFACE_PORT = "tmp", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}, %arg3: memref<8x8xi32> {hir.memref.ports = [{rd_latency = 1 : i64}], hls.INTERFACE_PORT = "A", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg4: memref<8x8xi32> {hir.memref.ports = [{rd_latency = 1 : i64}], hls.INTERFACE_PORT = "B", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg5: memref<8xi32> {hir.memref.ports = [{rd_latency = 1 : i64}], hls.INTERFACE_PORT = "X", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg6: memref<8xi32> {hir.memref.ports = [{wr_latency = 1 : i64}], hls.INTERFACE_PORT = "Y", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}) attributes {argNames = ["alpha", "beta", "tmp", "A", "B", "X", "Y"], hwAccel, llvm.linkage = #llvm.linkage<external>, resultNames = []} {
    %c0_i32 = arith.constant 0 : i32
    %0 = llvm.mlir.undef : i32
    %alloca = memref.alloca() {hir.memref.ports = [{rd_latency = 0 : i64}, {wr_latency = 1 : i64}], mem_kind = "reg"} : memref<1xi32>
    affine.store %0, %alloca[0] : memref<1xi32>
    %alloca_0 = memref.alloca() {hir.memref.ports = [{rd_latency = 0 : i64}, {wr_latency = 1 : i64}], mem_kind = "reg"} : memref<1xi32>
    affine.for %arg7 = 0 to 8 {
      affine.store %c0_i32, %alloca_0[0] : memref<1xi32>
      affine.store %c0_i32, %alloca[0] : memref<1xi32>
      affine.for %arg8 = 0 to 8 {
        %6 = affine.load %arg5[%arg8] : memref<8xi32>
        %7 = affine.load %arg3[%arg7, %arg8] : memref<8x8xi32>
        %8 = func.call @mul_i32(%7, %6) {result_delays = [1 : i32]} : (i32, i32) -> i32
        %9 = affine.load %arg4[%arg7, %arg8] : memref<8x8xi32>
        %10 = func.call @mul_i32(%9, %6) {result_delays = [1 : i32]} : (i32, i32) -> i32
        %11 = affine.load %alloca_0[0] : memref<1xi32>
        %12 = func.call @add_i32(%11, %8) {result_delays = [0 : i32]} : (i32, i32) -> i32
        affine.store %12, %alloca_0[0] : memref<1xi32>
        %13 = affine.load %alloca[0] : memref<1xi32>
        %14 = func.call @add_i32(%13, %10) {result_delays = [0 : i32]} : (i32, i32) -> i32
        affine.store %14, %alloca[0] : memref<1xi32>
      }
      %1 = affine.load %alloca_0[0] : memref<1xi32>
      affine.store %1, %arg2[%arg7] : memref<8xi32>
      %2 = affine.load %alloca[0] : memref<1xi32>
      %3 = func.call @mul_i32(%arg0, %1) {result_delays = [1 : i32]} : (i32, i32) -> i32
      %4 = func.call @mul_i32(%arg1, %2) {result_delays = [1 : i32]} : (i32, i32) -> i32
      %5 = func.call @add_i32(%3, %4) {result_delays = [0 : i32]} : (i32, i32) -> i32
      affine.store %5, %arg6[%arg7] : memref<8xi32>
    }
    return
  }
  func.func private @mul_i32(i32 {hir.delay = 0 : i64}, i32 {hir.delay = 0 : i64}) -> (i32 {hir.delay = 1 : i64, hls.INTERFACE_LATENCY = 1 : i64}) attributes {argNames = ["arg0", "arg1", "t"], llvm.linkage = #llvm.linkage<external>, resultNames = ["out"]}
  func.func private @add_i32(i32 {hir.delay = 0 : i64}, i32 {hir.delay = 0 : i64}) -> (i32 {hir.delay = 0 : i64, hls.INTERFACE_LATENCY = 0 : i64}) attributes {argNames = ["arg0", "arg1", "t"], llvm.linkage = #llvm.linkage<external>, resultNames = ["out"]}
}

