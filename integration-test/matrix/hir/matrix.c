#define A_ROWS 32
#define A_COLS 32
#define B_ROWS 32
#define B_COLS 32

#pragma HLS extern_func variable = add_i32 latency = 0
#pragma HLS extern_func variable = mul_i32 latency = 1
int add_i32(int a, int b);
int mul_i32(int a, int b);

void matrix(int inA[A_ROWS][A_COLS], int inB[A_COLS][B_COLS],
            int outC[A_ROWS][B_COLS]) {
#pragma HLS INTERFACE port = inA storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = inB storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = outC storage_type = ram_1p wr_latency = 1
#pragma scop
  for (int i = 0; i < A_ROWS; i++) {
#pragma HLS pipeline II = 2080
    for (int j = 0; j < B_COLS; j++) {
#pragma HLS pipeline II = 65
      int sumMult = 0;
      for (int k = 0; k < A_COLS; k++) {
#pragma HLS pipeline II = 2
        sumMult = add_i32(sumMult, mul_i32(inA[i][k], inB[k][j]));
      }
      outC[i][j] = sumMult;
    }
  }
#pragma endscop
}
