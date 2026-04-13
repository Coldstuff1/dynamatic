#define N 1024
#pragma HLS extern_func variable = add_i32 latency = 0
#pragma HLS extern_func variable = mul_i32 latency = 1
int add_i32(int a, int b);
int mul_i32(int a, int b);
void sumi3_mem(int a[N]) {
#pragma HLS INTERFACE port = a storage_type = ram_1p rd_latency = 1
#pragma scop
  int sum = 0;
  for (int i = 0; i < N; i++) {
#pragma HLS pipeline II = 1
    int x = a[i];
    sum = add_i32(sum, mul_i32(mul_i32(x, x), x));
  }
#pragma endscop
}
