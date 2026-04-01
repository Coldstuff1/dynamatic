#define IMG_SIZE 32
#define KERNEL_SIZE 5
static float abs(float v) { return v > 0 ? v : -v; }

void split(float output0[IMG_SIZE][IMG_SIZE], float output1[IMG_SIZE][IMG_SIZE],
           float input[IMG_SIZE][IMG_SIZE]) {
#pragma HLS INLINE
  for (int i = 0; i < IMG_SIZE; i++) {
    for (int j = 0; j < IMG_SIZE; j++) {
#pragma HLS PIPELINE
      output0[i][j] = input[i][j];
      output1[i][j] = input[i][j];
    }
  }
}

void convX(float output[IMG_SIZE][IMG_SIZE], float img[IMG_SIZE][IMG_SIZE],
           float kernel[KERNEL_SIZE]) {
#pragma HLS INLINE
  for (int i = 0; i < IMG_SIZE - KERNEL_SIZE; i++) {
    for (int j = 0; j < IMG_SIZE - KERNEL_SIZE; j++) {
      output[i][j] = 0;
      for (int kk = 0; kk < KERNEL_SIZE; kk++) {
#pragma HLS PIPELINE
        output[i][j] += kernel[kk] * img[i][j + kk];
      }
    }
  }
}

void convY(float output[IMG_SIZE][IMG_SIZE], float img[IMG_SIZE][IMG_SIZE],
           float kernel[KERNEL_SIZE]) {
#pragma HLS INLINE
  for (int i = 0; i < IMG_SIZE - KERNEL_SIZE; i++) {
    for (int j = 0; j < IMG_SIZE - KERNEL_SIZE; j++) {
      output[i][j] = 0;
      for (int kk = 0; kk < KERNEL_SIZE; kk++) {
#pragma HLS PIPELINE
        output[i][j] += kernel[kk] * img[i + kk][j];
      }
    }
  }
}

void sharpen(float output[IMG_SIZE][IMG_SIZE], float img[IMG_SIZE][IMG_SIZE],
             float blury[IMG_SIZE][IMG_SIZE], float weight) {
#pragma HLS INLINE
  for (int i = 0; i < IMG_SIZE; i++) {
    for (int j = 0; j < IMG_SIZE; j++) {
#pragma HLS PIPELINE
      output[i][j] = (1 + weight) * img[i][j] - weight * blury[i][j];
    }
  }
}

void mask(float output[IMG_SIZE][IMG_SIZE], float img[IMG_SIZE][IMG_SIZE],
          float blury[IMG_SIZE][IMG_SIZE], float sharp[IMG_SIZE][IMG_SIZE],
          float threshold) {
#pragma HLS INLINE
  for (int i = 0; i < IMG_SIZE; i++) {
    for (int j = 0; j < IMG_SIZE; j++) {
#pragma HLS PIPELINE
      output[i][j] =
          (abs(img[i][j] - blury[i][j]) < threshold ? img[i][j] : sharp[i][j]);
    }
  }
}

void unsharp_mask_hls(float img[IMG_SIZE][IMG_SIZE],
                      float mask_img[IMG_SIZE][IMG_SIZE],
                      float kernelDataX[KERNEL_SIZE],
                      float kernelDataY[KERNEL_SIZE]) {

#pragma HLS INLINE recursive
#pragma HLS INTERFACE mode = ap_memory port = img storage_type = rom_1p
#pragma HLS INTERFACE mode = ap_memory port = mask_img storage_type = ram_1p
#pragma HLS INTERFACE mode = ap_memory port = kernelDataX storage_type = rom_1p
#pragma HLS INTERFACE mode = ap_memory port = kernelDataY storage_type = rom_1p

#pragma HLS INTERFACE mode = ap_ctrl_none

  float blurxData[IMG_SIZE][IMG_SIZE];
  float bluryData[IMG_SIZE][IMG_SIZE];
  float sharpImgData[IMG_SIZE][IMG_SIZE];

  convX(blurxData, img, kernelDataX);
  convY(bluryData, blurxData, kernelDataY);
  sharpen(sharpImgData, img, bluryData, 3);
  mask(mask_img, img, bluryData, sharpImgData, 0.001);
}
