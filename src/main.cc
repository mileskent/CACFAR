#include <iostream>
#include <vector>
#include <cmath> // For std::abs

extern "C" void launch_vector_add (const float* a, const float* b, float* c, int n);

int main() {
    int n = 10000;
    std::vector<float> h_a(n, 1.5f);
    std::vector<float> h_b(n, 2.5f);
    std::vector<float> h_c(n, 0.0f);

    std::cout << "Launching HIP kernel for " << n << " elements..." << std::endl;

    launch_vector_add(h_a.data(), h_b.data(), h_c.data(), n);

    int errors = 0;
    float tolerance = 1e-5f;

    for (int i = 0; i < n; i++) {
        float expected = h_a[i] + h_b[i];
        if (std::abs(h_c[i] - expected) > tolerance) {
            if (errors < 10) {
                std::cerr
                    << "Verification failed at index " << i
                    << ": Got " << h_c[i]
                    << ", Expected " << expected << std::endl;
            }
            errors++;
        }
    }

    if (errors == 0) {
        std::cout << "SUCCESS: All " << n << " elements match expected values." << std::endl;
    } else {
        std::cerr << "FAILURE: Found " << errors << " mismatching elements." << std::endl;
        return 1;
    }

    return 0;
}
