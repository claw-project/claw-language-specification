all: gpu cpu

gpu: mo_column.f90
	clawfc --target=gpu --directive=openacc -o mo_column_gpu_openacc.f90 mo_column.f90

cpu: mo_column.f90
	clawfc --target=cpu --directive=openmp -o mo_column_cpu_openmp.f90 mo_column.f90

clean: 
	rm -rf *.xmod 
