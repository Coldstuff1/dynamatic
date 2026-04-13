#define N 128
#pragma HLS extern_func variable = add_i32 latency = 0
int add_i32(int a, int b);
void simple_example(int x[N]) {
#pragma HLS INTERFACE port = x storage_type = ram_1p wr_latency = 1
#pragma scop
  int y = 0;
  int incr = 1;
  for (int i = 0; i < N; ++i) {
#pragma HLS pipeline II = 1
    y = add_i32(y, incr);
    x[i] = y;
  }
#pragma endscop
}
