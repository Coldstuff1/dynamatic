#define N 1024
#pragma HLS extern_func variable = add_i32 latency = 1
#pragma HLS extern_func variable = mul_i32 latency = 1
int add_i32(int a, int b);
int mul_i32(int a, int b);
void iir(int y[N], int x[N], int c, int d, int y0) {
#pragma HLS INTERFACE port = y storage_type = ram_1p wr_latency = 1
#pragma HLS INTERFACE port = x storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = c storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = d storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = y0 storage_type = ram_1p rd_latency = 1
#pragma scop
  for (int j = 0; j < 1; j++) {
#pragma HLS pipeline II = 2048
    int temp = y0;
    for (int i = 1; i < N; i++) {
#pragma HLS pipeline II = 2
      temp = add_i32(mul_i32(c, temp), mul_i32(d, x[i]));
      y[i] = temp;
    }
  }
#pragma endscop
}
