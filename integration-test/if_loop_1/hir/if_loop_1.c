#pragma HLS extern_func variable = add_i32 latency = 0
#pragma HLS extern_func variable = mul_i32 latency = 1
int add_i32(int a, int b);
int mul_i32(int a, int b);
void if_loop_1(int a[128], int n) {
#pragma HLS INTERFACE port = a storage_type = ram_1p rd_latency = 1
#pragma HLS INTERFACE port = n storage_type = ram_1p rd_latency = 1
#pragma scop
  int sum = 0;
  for (int i = 0; i < n; i++) {
#pragma HLS PIPELINE II = 1
    int tmp = mul_i32(a[i], 5);
    if (tmp > 10)
      sum = add_i32(sum, tmp);
  }
#pragma endscop
}
