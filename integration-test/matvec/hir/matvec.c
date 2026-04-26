#define N 8

#pragma HLS extern_func variable = add_i32 latency = 0
#pragma HLS extern_func variable = mul_i32 latency = 1
int add_i32(int a, int b);
int mul_i32(int a, int b);

void matvec(int m[N][N], int v[N], int out[N]) {
#pragma HLS INTERFACE port = m storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = v storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = out storage_type = ram_1p wr_latency = 1
#pragma scop
  for (int i = 0; i < N; i++) {
#pragma HLS pipeline II = 17
    int tmp = 0;
    for (int j = 0; j < N; j++) {
#pragma HLS pipeline II = 2
      tmp = add_i32(tmp, mul_i32(v[j], m[i][j]));
    }
    out[i] = tmp;
  }
#pragma endscop
}
