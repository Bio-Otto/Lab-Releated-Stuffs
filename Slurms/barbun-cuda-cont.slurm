#!/bin/bash
#SBATCH -p barbun-cuda
#SBATCH -A hozdemir
#SBATCH -J 4jfe_TCR_250ns
#SBATCH -N 1
#SBATCH -n 40
#SBATCH --gres=gpu:2
#SBATCH --time=15-00:00:00
#SBATCH --mail-user=ozdemir.genetik@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err


module purge
source /truba/sw/centos7.3/comp/intel/PS2019-update1/bin/compilervars.sh intel64
source /truba/home/hozdemir/gmx-derleme/gromacs-2021.3/bin/bin/GMXRC
source /truba/home/hozdemir/gmx-derleme/gromacs-2021.3/bin/bin/gmx_mpi
module load centos7.3/comp/cmake/3.18.0
module load centos7.3/comp/gcc/7
module load centos7.3/lib/openmpi/4.0.1-gcc-7.0.1
module load centos7.3/lib/cuda/10.1



export OMP_NUM_THREADS=20

echo "SLURM_NODELIST $SLURM_NODELIST"
echo "NUMBER OF CORES $SLURM_NTASKS"





GROMACS_DIR=/truba/home/hozdemir/gmx-derleme/gromacs-2021.3/bin/bin
#mpirun -np 8 $GROMACS_DIR/gmx_mpi  mdrun -ntomp 10 -s 4jfe_TCR_250ns.tpr -cpi state.cpt

# Continue a Simulation
mpirun $GROMACS_DIR/gmx_mpi mdrun -s 4jfe_TCR_250ns.tpr -cpi state.cpt

exit





