#include "dynamatic/Integration.h"
#define add_i32(a, b) (a + b)
#define mul_i32(a, b) (a * b)
void gesummv(int alpha, int beta, int tmp[8], int A[8][8], int B[8][8],
             int X[8], int Y[8]) {
#pragma HLS INTERFACE port = tmp storage_type = ram_1p wr_latency = 1
#pragma HLS INTERFACE port = A storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = B storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = X storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = Y storage_type = ram_1p wr_latency = 1

  for (int i = 0; i < 8; i++) {
#pragma HLS pipeline II = 18
    int tmp_reg = 0;
    int y_reg = 0;
    for (int j = 0; j < 8; j++) {
#pragma HLS pipeline II = 1
      int xj = X[j];
      int t1 = mul_i32(A[i][j], xj);
      int t2 = mul_i32(B[i][j], xj);
      tmp_reg = add_i32(tmp_reg, t1);
      y_reg = add_i32(y_reg, t2);
    }
    tmp[i] = tmp_reg;
    int y_i = y_reg;
    Y[i] = add_i32(mul_i32(alpha, tmp_reg), mul_i32(beta, y_i));
  }
}

int main(void) {
  int alpha = 1;
  int beta = 1;
  int tmp[8];
  int A[8][8];
  int B[8][8];
  int X[8];
  int Y[8];
  CALL_KERNEL(gesummv, alpha, beta, tmp, A, B, X, Y);
  return 0;
}