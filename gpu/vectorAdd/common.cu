#include "common.h"

void printDeviceProperties()
{
	struct cudaDeviceProp deviceProp;
	int ret = cudaGetDeviceProperties(&deviceProp, 0);
	CPE(ret != cudaSuccess, "Get Device Properties failed\n", -1);

	printf("Device name: %s\n", deviceProp.name);
	printf("Total global memory: %lu bytes\n", deviceProp.totalGlobalMem);
	printf("Warp size: %d\n", deviceProp.warpSize);
	printf("Compute capability: %d.%d\n", deviceProp.major, deviceProp.minor);

	printf("Multi-processor count: %d\n", deviceProp.multiProcessorCount);
	printf("Threads per multi-processor: %d\n", deviceProp.maxThreadsPerMultiProcessor);
}

// Like printf, but red. Limited to 1000 characters.
void red_printf(const char *format, ...)
{	
	#define RED_LIM 1000
	va_list args;
	int i;

	char buf1[RED_LIM], buf2[RED_LIM];
	memset(buf1, 0, RED_LIM);
	memset(buf2, 0, RED_LIM);

    va_start(args, format);

	// Marshal the stuff to print in a buffer
	vsnprintf(buf1, RED_LIM, format, args);

	// Probably a bad check for buffer overflow
	for(i = RED_LIM - 1; i >= RED_LIM - 50; i --) {
		assert(buf1[i] == 0);
	}

	// Add markers for red color and reset color
	snprintf(buf2, 1000, "\033[31m%s\033[0m", buf1);

	// Probably another bad check for buffer overflow
	for(i = RED_LIM - 1; i >= RED_LIM - 50; i --) {
		assert(buf2[i] == 0);
	}

	printf("%s", buf2);

    va_end(args);
}
