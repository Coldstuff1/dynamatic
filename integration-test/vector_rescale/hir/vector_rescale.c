#define N 1024

#pragma HLS extern_func variable = mul_i32 latency = 1
int mul_i32(int a, int b);

void vector_rescale(int a[N], int c, int b[N]) {
#pragma HLS INTERFACE port = a storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = b storage_type = ram_1p wr_latency = 1
#pragma scop
  for (int i = 0; i < N; ++i) {
#pragma HLS pipeline II = 3
    b[i] = mul_i32(a[i], c);
  }
#pragma endscop
}
