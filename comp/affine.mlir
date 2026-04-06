module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @gesummv(%arg0: i32 {hls.INTERFACE_LATENCY = 0 : i64}, %arg1: i32 {hls.INTERFACE_LATENCY = 0 : i64}, %arg2: memref<8xi32> {hls.INTERFACE_PORT = "tmp", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}, %arg3: memref<8x8xi32> {hls.INTERFACE_PORT = "A", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg4: memref<8x8xi32> {hls.INTERFACE_PORT = "B", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg5: memref<8xi32> {hls.INTERFACE_PORT = "X", hls.INTERFACE_RD_LATENCY = 1 : i64, hls.INTERFACE_STORAGE_TYPE = "ram_1p"}, %arg6: memref<8xi32> {hls.INTERFACE_PORT = "Y", hls.INTERFACE_STORAGE_TYPE = "ram_1p", hls.INTERFACE_WR_LATENCY = 1 : i64}) attributes {argNames = ["alpha", "beta", "tmp", "A", "B", "X", "Y"], llvm.linkage = #llvm.linkage<external>, resultNames = []} {
    %c0_i32 = arith.constant 0 : i32
    %0 = llvm.mlir.undef : i32
    %alloca = memref.alloca() : memref<i32>
    affine.store %0, %alloca[] : memref<i32>
    %alloca_0 = memref.alloca() : memref<i32>
    affine.store %0, %alloca_0[] : memref<i32>
    affine.for %arg7 = 0 to 8 {
      affine.store %c0_i32, %alloca_0[] : memref<i32>
      affine.store %c0_i32, %alloca[] : memref<i32>
      affine.for %arg8 = 0 to 8 {
        %6 = affine.load %arg5[%arg8] : memref<8xi32>
        %7 = affine.load %arg3[%arg7, %arg8] : memref<8x8xi32>
        %8 = func.call @mul_i32(%7, %6) : (i32, i32) -> i32
        %9 = affine.load %arg4[%arg7, %arg8] : memref<8x8xi32>
        %10 = func.call @mul_i32(%9, %6) : (i32, i32) -> i32
        %11 = affine.load %alloca_0[] : memref<i32>
        %12 = func.call @add_i32(%11, %8) : (i32, i32) -> i32
        affine.store %12, %alloca_0[] : memref<i32>
        %13 = affine.load %alloca[] : memref<i32>
        %14 = func.call @add_i32(%13, %10) : (i32, i32) -> i32
        affine.store %14, %alloca[] : memref<i32>
      } {hls.PIPELINE_II = 1 : i64}
      %1 = affine.load %alloca_0[] : memref<i32>
      affine.store %1, %arg2[%arg7] : memref<8xi32>
      %2 = affine.load %alloca[] : memref<i32>
      %3 = func.call @mul_i32(%arg0, %1) : (i32, i32) -> i32
      %4 = func.call @mul_i32(%arg1, %2) : (i32, i32) -> i32
      %5 = func.call @add_i32(%3, %4) : (i32, i32) -> i32
      affine.store %5, %arg6[%arg7] : memref<8xi32>
    } {hls.PIPELINE_II = 18 : i64}
    return
  }
  func.func private @mul_i32(i32 {hls.INTERFACE_LATENCY = 0 : i64}, i32 {hls.INTERFACE_LATENCY = 0 : i64}) -> (i32 {hls.INTERFACE_LATENCY = 1 : i64}) attributes {argNames = ["a", "b"], llvm.linkage = #llvm.linkage<external>, resultNames = ["out"]}
  func.func private @add_i32(i32 {hls.INTERFACE_LATENCY = 0 : i64}, i32 {hls.INTERFACE_LATENCY = 0 : i64}) -> (i32 {hls.INTERFACE_LATENCY = 0 : i64}) attributes {argNames = ["a", "b"], llvm.linkage = #llvm.linkage<external>, resultNames = ["out"]}
}
