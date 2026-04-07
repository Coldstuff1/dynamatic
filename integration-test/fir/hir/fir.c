//===- fir.c - Computes FIR of two integer arrays -----------------*- C -*-===//
//
// Declares the fir kernel which computes a finite impulse response (FIR)
// between two discrete signals.
//
//===----------------------------------------------------------------------===//
#pragma HLS extern_func variable = add_i32 latency = 0
#pragma HLS extern_func variable = mul_i32 latency = 1
int add_i32(int a, int b);
int mul_i32(int a, int b);
void fir(int di[1024], int idx[1024]) {
#pragma HLS INTERFACE port = di storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = idx storage_type = ram_1p rd_latency = 1
#pragma scop
  int tmp = 0;
  for (int i = 0; i < 1024; i++) {
#pragma HLS pipeline II = 1
    tmp = add_i32(tmp, mul_i32(idx[i], di[1023 - i]));
  }
#pragma endscop
}
