all: gpu cpu

# For GPU target with OpenACC directives
gpu: mo_column.f90 main.f90
	clawfc --target=gpu --directive=openacc -o mo_column_gpu_openacc.f90 mo_column.f90
	clawfc -o main_gpu_openacc.f90 main.f90

# For CPU target with OpenMP directives
cpu: mo_column.f90 main.f90
	clawfc --target=cpu --directive=openmp -o mo_column_cpu_openmp.f90 mo_column.f90
	clawfc -o main_cpu_openmp.f90 main.f90
clean: 
	rm -rf *.xmod 
