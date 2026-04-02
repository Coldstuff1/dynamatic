module {
  hir.func.extern @mul_i32 at %arg2 (%arg0 : i32 delay 0, %arg1 : i32 delay 0) -> (%out : i32 delay 1) {argNames = ["a", "b", "t"], resultNames = ["out"]}
  hir.func.extern @add_i32 at %arg2 (%arg0 : i32 delay 0, %arg1 : i32 delay 0) -> (%out : i32 delay 0) {argNames = ["a", "b", "t"], resultNames = ["out"]}
  hir.func @gesummv_hir at %arg7 (%arg0 : i32 delay 0, %arg1 : i32 delay 0, %arg2 : !hir.memref<8x i32> ports [{wr_latency = 1 : i64}], %arg3 : !hir.memref<8x8x i32> ports [{rd_latency = 1 : i64}], %arg4 : !hir.memref<8x8x i32> ports [{rd_latency = 1 : i64}], %arg5 : !hir.memref<8x i32> ports [{rd_latency = 1 : i64}], %arg6 : !hir.memref<8x i32> ports [{wr_latency = 1 : i64}]){
    %c0_i32 = hw.constant 0 : i32
    %0 = hir.alloca  reg  : <(bank 1)x i32> ports [{rd_latency = 0 : i64}, {wr_latency = 1 : i64}]
    %1 = hir.alloca  reg  : <(bank 1)x i32> ports [{rd_latency = 0 : i64}, {wr_latency = 1 : i64}]
    %c0_i64 = hw.constant 0 : i64
    %c8_i64 = hw.constant 8 : i64
    %c1_i64 = hw.constant 1 : i64
    %iterResults:2, %t_end = hir.for %arg10 : i64 = %c0_i64 to %c8_i64 step %c1_i64 iter_args(%arg8=%arg0: i32,%arg9=%arg1: i32) iter_time( %arg11 = %arg7){
      %c0 = arith.constant 0 : index
      hir.store %c0_i32 to %1[port 1] [%c0] at %arg11 : !hir.memref<(bank 1)x i32> delay 1
      %c0_0 = arith.constant 0 : index
      hir.store %c0_i32 to %0[port 1] [%c0_0] at %arg11 : !hir.memref<(bank 1)x i32> delay 1
      %c0_i64_1 = hw.constant 0 : i64
      %c8_i64_2 = hw.constant 8 : i64
      %c1_i64_3 = hw.constant 1 : i64
      %iterResults_4, %t_end_5 = hir.for %arg13 : i64 = %c0_i64_1 to %c8_i64_2 step %c1_i64_3 iter_args(%arg12=%arg10: i64) iter_time( %arg14 = %arg11){
        %c0_i64_12 = hw.constant 0 : i64
        %c1_i64_13 = hw.constant 1 : i64
        %19 = comb.mul %c1_i64_13, %arg12 : i64
        %20 = comb.add %c0_i64_12, %19 : i64
        %c0_i64_14 = hw.constant 0 : i64
        %21 = comb.mul %c0_i64_14, %arg13 : i64
        %22 = comb.add %20, %21 : i64
        %23 = comb.extract %22 from 0 : (i64) -> i3
        %c0_i64_15 = hw.constant 0 : i64
        %c0_i64_16 = hw.constant 0 : i64
        %24 = comb.mul %c0_i64_16, %arg12 : i64
        %25 = comb.add %c0_i64_15, %24 : i64
        %c1_i64_17 = hw.constant 1 : i64
        %26 = comb.mul %c1_i64_17, %arg13 : i64
        %27 = comb.add %25, %26 : i64
        %28 = comb.extract %27 from 0 : (i64) -> i3
        %29 = hir.load %arg3[port 0] [%23, %28] at %arg14  : !hir.memref<8x8x i32> delay 1
        %c0_i64_18 = hw.constant 0 : i64
        %c1_i64_19 = hw.constant 1 : i64
        %30 = comb.mul %c1_i64_19, %arg13 : i64
        %31 = comb.add %c0_i64_18, %30 : i64
        %32 = comb.extract %31 from 0 : (i64) -> i3
        %33 = hir.load %arg5[port 0] [%32] at %arg14  : !hir.memref<8x i32> delay 1
        %34 = comb.mul %29, %33 : i32
        %c0_i64_20 = hw.constant 0 : i64
        %c1_i64_21 = hw.constant 1 : i64
        %35 = comb.mul %c1_i64_21, %arg12 : i64
        %36 = comb.add %c0_i64_20, %35 : i64
        %c0_i64_22 = hw.constant 0 : i64
        %37 = comb.mul %c0_i64_22, %arg13 : i64
        %38 = comb.add %36, %37 : i64
        %39 = comb.extract %38 from 0 : (i64) -> i3
        %c0_i64_23 = hw.constant 0 : i64
        %c0_i64_24 = hw.constant 0 : i64
        %40 = comb.mul %c0_i64_24, %arg12 : i64
        %41 = comb.add %c0_i64_23, %40 : i64
        %c1_i64_25 = hw.constant 1 : i64
        %42 = comb.mul %c1_i64_25, %arg13 : i64
        %43 = comb.add %41, %42 : i64
        %44 = comb.extract %43 from 0 : (i64) -> i3
        %45 = hir.load %arg4[port 0] [%39, %44] at %arg14  : !hir.memref<8x8x i32> delay 1
        hir.probe %45 name "tmp0" : i32
        %46 = hir.time %arg14 + 1 : !hir.time
        hir.probe %46 name "tmp0_valid" : !hir.time
        %47 = comb.mul %45, %33 : i32
        %c0_26 = arith.constant 0 : index
        %48 = hir.load %1[port 0] [%c0_26] at %arg14 + 1  : !hir.memref<(bank 1)x i32> delay 0
        %49 = comb.add %48, %34 : i32
        %c0_27 = arith.constant 0 : index
        hir.store %49 to %1[port 1] [%c0_27] at %arg14 + 1 : !hir.memref<(bank 1)x i32> delay 1
        %c0_28 = arith.constant 0 : index
        %50 = hir.load %0[port 0] [%c0_28] at %arg14 + 1  : !hir.memref<(bank 1)x i32> delay 0
        %51 = comb.add %50, %47 : i32
        %c0_29 = arith.constant 0 : index
        hir.store %51 to %0[port 1] [%c0_29] at %arg14 + 1 : !hir.memref<(bank 1)x i32> delay 1
        %52 = hir.delay %arg12 by 1 at %arg14  : i64 
        hir.next_iter iter_args(%52) at %arg14 + 1 : (i64)
      } {initiation_interval = 1 : i64}
      %c0_6 = arith.constant 0 : index
      %2 = hir.load %1[port 0] [%c0_6] at %arg11 + 9  : !hir.memref<(bank 1)x i32> delay 0
      %3 = hir.delay %arg10 by 9 at %arg11  : i64 
      %c0_i64_7 = hw.constant 0 : i64
      %c1_i64_8 = hw.constant 1 : i64
      %4 = comb.mul %c1_i64_8, %3 : i64
      %5 = comb.add %c0_i64_7, %4 : i64
      %6 = comb.extract %5 from 0 : (i64) -> i3
      hir.store %2 to %arg2[port 0] [%6] at %arg11 + 9 : !hir.memref<8x i32> delay 1
      %c0_9 = arith.constant 0 : index
      %7 = hir.load %0[port 0] [%c0_9] at %arg11 + 9  : !hir.memref<(bank 1)x i32> delay 0
      %8 = hir.delay %arg8 by 9 at %arg11  : i32 
      %9 = comb.mul %8, %2 : i32
      %10 = hir.delay %arg9 by 9 at %arg11  : i32 
      %11 = comb.mul %10, %7 : i32
      %12 = comb.add %9, %11 : i32
      %13 = hir.delay %arg10 by 9 at %arg11  : i64 
      %c0_i64_10 = hw.constant 0 : i64
      %c1_i64_11 = hw.constant 1 : i64
      %14 = comb.mul %c1_i64_11, %13 : i64
      %15 = comb.add %c0_i64_10, %14 : i64
      %16 = comb.extract %15 from 0 : (i64) -> i3
      hir.store %12 to %arg6[port 0] [%16] at %arg11 + 9 : !hir.memref<8x i32> delay 1
      %17 = hir.delay %arg8 by 18 at %arg11  : i32 
      %18 = hir.delay %arg9 by 18 at %arg11  : i32 
      hir.next_iter iter_args(%17, %18) at %arg11 + 18 : (i32, i32)
    } {initiation_interval = 18 : i64}
    hir.return
  } {argNames = ["alpha", "beta", "tmp", "A", "B", "X", "Y", "t"]}
}

