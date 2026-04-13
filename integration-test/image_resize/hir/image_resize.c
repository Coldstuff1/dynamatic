#define N 32
#pragma HLS extern_func variable = add_i32 latency = 0
int add_i32(int a, int b);
void image_resize(int a[N][N], int c) {
#pragma HLS INTERFACE port = a storage_type = ram_2p rd_latency =              \
    1 wr_latency = 1
#pragma HLS INTERFACE port = c storage_type = ram_1p rd_latency = 0
#pragma scop
  for (int i = 0; i < N; i++) {
#pragma HLS pipeline II = N
    for (int j = 0; j < N; j++) {
#pragma HLS pipeline II = 1
      int tmp = 0;
      tmp = a[i][j];
      a[i][j] = add_i32(c, tmp);
    }
  }
#pragma endscop
}