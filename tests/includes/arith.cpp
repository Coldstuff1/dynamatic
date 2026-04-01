#include <cstdint>
#include <iostream>

extern "C" int32_t add_f32_hw(int32_t a, int32_t b) {
  float aa = reinterpret_cast<float &>(a);
  float bb = reinterpret_cast<float &>(b);
  float result = aa + bb;
  return reinterpret_cast<int32_t &>(result);
}
extern "C" int32_t sub_f32_hw(int32_t a, int32_t b) {
  float aa = reinterpret_cast<float &>(a);
  float bb = reinterpret_cast<float &>(b);
  float result = aa - bb;
  return reinterpret_cast<int32_t &>(result);
}
extern "C" int32_t mul_f32_hw(int32_t a, int32_t b) {
  float aa = reinterpret_cast<float &>(a);
  float bb = reinterpret_cast<float &>(b);
  float result = aa * bb;
  return reinterpret_cast<int32_t &>(result);
}

extern "C" char ugt_f32_hw(int32_t a, int32_t b) {
  float aa = reinterpret_cast<float &>(a);
  float bb = reinterpret_cast<float &>(b);
  return aa > bb ? 1 : 0;
}
extern "C" int32_t neg_f32_hw(int32_t a) {
  float aa = reinterpret_cast<float &>(a);
  float result = -aa;
  return reinterpret_cast<int32_t &>(result);
}
extern "C" int32_t select_f32_hw(char cmp, int32_t a, int32_t b) {
  return cmp ? a : b;
}

extern "C" float add_f32(float a, float b) { return a + b; }
extern "C" float sub_f32(float a, float b) { return a - b; }
extern "C" float mul_f32(float a, float b) { return a * b; }
extern "C" char ugt_f32(float a, float b) { return a > b ? 1 : 0; }
extern "C" float neg_f32(float a) { return -a; }
extern "C" float select_f32(char cmp, float a, float b) { return cmp ? a : b; }
