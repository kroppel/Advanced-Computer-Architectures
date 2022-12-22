#include <iostream>
#include <chrono>
#include <random>
#include "Timer.cuh"
#include "CheckError.cuh"

using namespace timer;

// Macros
#define DIV(a, b)   (((a) + (b) - 1) / (b))

const int N  = 16777216;
#define BLOCK_SIZE 256

__global__ void ReduceKernelLowDivergence(int* VectorIN, int N) {
	__shared__ int SMem[1024];
	int GlobalIndex = blockIdx.x * blockDim.x + threadIdx.x;
	SMem[threadIdx.x] = VectorIN[GlobalIndex];
	__syncthreads();

	for (int i = 1; i < blockDim.x; i *= 2) {
		int index = threadIdx.x * i * 2;
		if (index < blockDim.x)
			SMem[index] += SMem[index + i];
		__syncthreads();
	}
	if (threadIdx.x == 0)
		VectorOUT[blockIdx.x] = SMem[0];
}

int main() {
    
	// ------------------- INIT ------------------------------------------------

	// Random Engine Initialization
	unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
	std::default_random_engine generator (seed);
	std::uniform_int_distribution<int> distribution(1, 100);

	Timer<HOST> host_TM;
	Timer<DEVICE> dev_TM;

	// ------------------ HOST INIT --------------------------------------------

	int* VectorIN = new int[N];
	for (int i = 0; i < N; ++i)
		VectorIN[i] = distribution(generator);

	// ------------------- CUDA INIT -------------------------------------------

	int* devVectorIN;
	SAFE_CALL( cudaMalloc(&devVectorIN, N * sizeof(int)) );
	
	SAFE_CALL( cudaMemcpy(devVectorIN, VectorIN, N * sizeof(int),
                 cudaMemcpyHostToDevice) );
	
	int sum;
	float dev_time;

	// ------------------- CUDA COMPUTATION  ----------------------------------

	std::cout<<"Starting computation on DEVICE "<<std::endl;

	dev_TM.start();

	ReduceKernelLowDivergence<<<DIV(N, BLOCK_SIZE), BLOCK_SIZE>>>
		(devVectorIN, N);
	ReduceKernelLowDivergence<<<DIV(N, BLOCK_SIZE* BLOCK_SIZE), BLOCK_SIZE>>>
	 	(devVectorIN, DIV(N, BLOCK_SIZE));
	ReduceKernelLowDivergence<<<DIV(N, BLOCK_SIZE * BLOCK_SIZE * BLOCK_SIZE), BLOCK_SIZE>>>
	 	(devVectorIN, DIV(N, BLOCK_SIZE * BLOCK_SIZE));

	dev_TM.stop();
	dev_time1 = dev_TM.duration();
	CHECK_CUDA_ERROR;

	SAFE_CALL( cudaMemcpy(&sum, devVectorIN, sizeof(int),
	    	cudaMemcpyDeviceToHost) );

	// ------------------- HOST ------------------------------------------------
	host_TM.start();

	int host_sum = std::accumulate(VectorIN, VectorIN + N, 0);

	host_TM.stop();

	std::cout << std::setprecision(3)
	      << "KernelTime Divergent: " << dev_time << std::endl
	      << "HostTime            : " << host_TM.duration() << std::endl
	      << std::endl;

	// ------------------------ VERIFY -----------------------------------------

	if (host_sum != sum) {
	std::cerr << std::endl
		  << "Error! Wrong result. Host value: " << host_sum
		  << " , Device value: " << sum
		  << std::endl << std::endl;
	cudaDeviceReset();
	std::exit(EXIT_FAILURE);
	}

	//-------------------------- SPEEDUP ---------------------------------------

	float speedup = host_TM.duration() / dev_time;

	std::cout << "Correct result" << std::endl
	      << "Speedup achieved: " << std::setprecision(3)
	      << speedup << " x" << std::endl << std::endl;

	std::cout << host_TM.duration() << ";" << dev_TM.duration() << ";" << host_TM.duration() / 			dev_TM.duration() << std::endl;

	delete[] VectorIN;
	SAFE_CALL( cudaFree(devVectorIN) );
	cudaDeviceReset();
	}
