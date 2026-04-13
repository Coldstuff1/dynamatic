#include "vector_rescale.h"
#include "dynamatic/Integration.h"
#include <stdlib.h>

void vector_rescale(in_int_t a[N], in_int_t c, inout_int_t b[N]) {
  for (unsigned i = 0; i < N; ++i)
    b[i] = a[i] * c;
}

int main(void) {
  in_int_t a[N];
  in_int_t c;
  inout_int_t b[N];

  srand(13);
  c = rand() % 100;
  for (unsigned j = 0; j < N; ++j)
    a[j] = rand() % 100;

  CALL_KERNEL(vector_rescale, a, c, b);
  return 0;
}
