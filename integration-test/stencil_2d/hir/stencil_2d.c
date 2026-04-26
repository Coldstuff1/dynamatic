#define N 1024
#define M 16

#pragma HLS extern_func variable = add_i32 latency = 0
#pragma HLS extern_func variable = mul_i32 latency = 1
int add_i32(int a, int b);
int mul_i32(int a, int b);

void stencil_2d(int orig[N], int filter[M], int sol[N]) {
#pragma HLS INTERFACE port = orig storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = filter storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = sol storage_type = ram_1p wr_latency = 1
#pragma scop
  for (int c = 0; c < 28; c++) {
#pragma HLS pipeline II = 19
    int temp = 0;
    for (int k1 = 0; k1 < 3; k1++) {
#pragma HLS pipeline II = 6
      for (int k2 = 0; k2 < 3; k2++) {
#pragma HLS pipeline II = 2
        temp =
            add_i32(temp, mul_i32(filter[k1 * 3 + k2], orig[k1 * 30 + c + k2]));
      }
    }
    sol[c] = temp;
  }
#pragma endscop
}
