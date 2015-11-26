#include<stdio.h>
#define N 10000
// Kernel definition
__global__ 
void VecAdd(int* A, int* B, int* C)
{
    int i = threadIdx.x;
    C[i] = A[i] + B[i];
    //printf("%i ",C[i]);
}

int main()
{
    int A[N],B[N],C[N],*d_a,*d_b,*d_c;
    int i;
    for(i=0;i<N;i++){
	A[i]=1;
	B[i]=1;
    }
    cudaMalloc((void**)&d_a,N*sizeof(int));
    cudaMalloc((void**)&d_b,N*sizeof(int)); 
    cudaMalloc((void**)&d_c,N*sizeof(int));

    cudaMemcpy(d_a,A,N*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(d_b,B,N*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(d_c,C,N*sizeof(int),cudaMemcpyHostToDevice);
 
    VecAdd<<<(N/1024)+1, N>>>(d_a, d_b, d_c);

    //cudaMemcpy(A,d_a,N*sizeof(int),cudaMemcpyHostToDevice);
    //cudaMemcpy(B,d_b,N*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(C,d_c,N*sizeof(int),cudaMemcpyDeviceToHost);     

    for(i=0;i<N;i++){
	printf("%i ",C[i]);
    }
    printf("\n");
    cudaDeviceSynchronize();    
	
    return 0;
}
