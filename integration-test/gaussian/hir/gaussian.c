#define N 16
#define N_DEC 15
#define N_DEC_DEC 14

#pragma HLS extern_func variable = add_i32 latency = 0
#pragma HLS extern_func variable = sub_i32 latency = 0
#pragma HLS extern_func variable = mul_i32 latency = 1
int add_i32(int a, int b);
int sub_i32(int a, int b);
int mul_i32(int a, int b);

void gaussian(int c[N], int a[N][N]) {
#pragma HLS INTERFACE port = c storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = a storage_type = ram_1p rd_latency =              \
    1 wr_latency = 1
#pragma scop
  int sum = 0;
  for (int j = 1; j <= N_DEC_DEC; j++) {
#pragma HLS pipeline II = 585
    for (int i = j + j; i <= N_DEC_DEC; i++) {
#pragma HLS pipeline II = 45
      for (int k = 1; k <= N_DEC; k++) {
#pragma HLS pipeline II = 3
        a[i][k] = sub_i32(a[i][k], mul_i32(c[j], a[j][k]));
        sum = add_i32(sum, k);
      }
    }
  }
#pragma endscop
}
