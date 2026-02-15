#include <hip/hip_runtime.h>
#include <iostream>

#define HIP_CHECK(command) { \
    hipError_t status = command; \
    if (status != hipSuccess) { \
        std::cerr \
            << "Error: HIP reports " << hipGetErrorString(status) \
            << " at " << __FILE__ << ":" << __LINE__ << std::endl; \
        exit(1); \
    } \
}

__global__ void vector_add_kernel(const float* a, const float* b, float* c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) c[i] = a[i] + b[i];
}

extern "C" void launch_vector_add(const float* a, const float* b, float* c, int n) {
    float *d_a, *d_b, *d_c;
    size_t bytes = n * sizeof(float);

    HIP_CHECK(hipMalloc(&d_a, bytes));
    HIP_CHECK(hipMalloc(&d_b, bytes));
    HIP_CHECK(hipMalloc(&d_c, bytes));

    HIP_CHECK(hipMemcpy(d_a, a, bytes, hipMemcpyHostToDevice));
    HIP_CHECK(hipMemcpy(d_b, b, bytes, hipMemcpyHostToDevice));

    int threads = 256;
    int blocks = (n + threads - 1) / threads;

    hipLaunchKernelGGL(vector_add_kernel, dim3(blocks), dim3(threads), 0, 0, d_a, d_b, d_c, n);

    HIP_CHECK(hipMemcpy(c, d_c, bytes, hipMemcpyDeviceToHost));

    HIP_CHECK(hipFree(d_a));
    HIP_CHECK(hipFree(d_b));
    HIP_CHECK(hipFree(d_c));
}
