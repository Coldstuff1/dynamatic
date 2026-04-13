#define N 128
#pragma HLS extern_func variable = add_i32 latency = 0
#pragma HLS extern_func variable = mul_i32 latency = 1
int add_i32(int a, int b);
int mul_i32(int a, int b);
void polyn_mult(int a[N], int b[N], int out[N]) {
#pragma HLS INTERFACE port = a storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = b storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = out storage_type = ram_1p wr_latency = 1
  int temp[N];
#pragma HLS bind_storage variable = temp type = ram_2p impl =                  \
    bram rd_latency = 1 wr_latency = 1
#pragma scop
  for (int k = 0; k < N; k++) {
#pragma HLS pipeline II = 2
    temp[k] = 0;
    for (int i = 1; i < N - k; i++) {
#pragma HLS pipeline II = 2
      temp[k] = add_i32(temp[k], mul_i32(a[k + i], b[N - i]));
    }
    for (int i = 0; i < k + 1; i++) {
#pragma HLS pipeline II = 2
      temp[k] = add_i32(temp[k], mul_i32(a[k - i], b[i]));
    }
  }
  for (int k = 0; k < N; k++) {
#pragma HLS pipeline II = 2
    out[k] = temp[k];
  }
#pragma endscop
}
