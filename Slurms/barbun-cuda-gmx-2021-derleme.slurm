
# ######################################################################################## #
# --------------------> GROMACS 2021.3 BARBUN-CUDA DERLEME PROSEDÜRÜ <-------------------- #
# ######################################################################################## #


#Barbun-cuda HPC sistemi toplamda 2 node 40 CPU ve 2 GPU olarak kullanılabilir.

cd /truba/home/hozdemir
mkdir gmx-derleme
cd gmx-derleme
wget ftp://ftp.gromacs.org/gromacs/gromacs-2021.3.tar.gz
tar -xzvf gromacs-2021.3.tar.gz
cd gromacs-2021.3

mkdir build
cd build

# Barbun-cuda minimum gereksinim olarak 20 CPU ve 1 GPU olduğundan kurulumda o şekilde kullandım.

srun -A hozdemir -p barbun-cuda -N 1 -n 40 --gres=gpu:1 --time=15-00:00:00  --job-name "install" --pty bash -i


module purge
#source /truba/sw/centos7.9/comp/intel/PS2020-update4/bin/compilervars.sh intel64
module load centos7.3/comp/cmake/3.18.0
module load centos7.3/comp/gcc/7
module load centos7.3/lib/openmpi/4.0.1-gcc-7.0.1
module load centos7.3/lib/cuda/10.1

export CC=mpicc
export CXX=mpic++


cmake .. -DCMAKE_C_COMPILER=mpicc -DCMAKE_CXX_COMPILER=mpic++ -DGMX_MPI=on -DGMX_BUILD_OWN_FFTW=ON -DGMX_SIMD=AVX_512 -DGMX_GPU=CUDA -DCUDA_TOOLKIT_ROOT_DIR=/truba/sw/centos7.3/lib/cuda/10.1 -DCMAKE_INSTALL_PREFIX=/truba/home/hozdemir/gmx-derleme/gromacs-2021.3/bin

make -j4 all
# make check
make install