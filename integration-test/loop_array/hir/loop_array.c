#define N 16
#pragma HLS extern_func variable = add_i32 latency = 0
int add_i32(int a, int b);
void loop_array(int k, int c[N]) {
#pragma HLS INTERFACE port = k storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = c storage_type = ram_2p rd_latency =              \
    1 wr_latency = 1
#pragma scop
  for (int i = 1; i < N; i++) {
#pragma HLS pipeline II = 1
    c[i] = add_i32(k, c[i - 1]);
  }
#pragma endscop
}
