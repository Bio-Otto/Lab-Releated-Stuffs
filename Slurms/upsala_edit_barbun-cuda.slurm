#!/bin/bash
#SBATCH -p barbun-cuda
#SBATCH -A hozdemir
#SBATCH -J 3o4l_TCRpMHC_250ns
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

# Automatic selection of single or multi node based GROMACS
if [ $SLURM_JOB_NUM_NODES -gt 1 ]; then
  GMX="gmx_mpi"
  MPIRUN="mpirun"
  ntmpi=""
else
  GMX="gmx"
  MPIRUN=""
  ntmpi="-ntmpi $SLURM_NTASKS"
fi

# Automatic selection of ntomp argument based on "-c" argument to sbatch
if [ -n "$SLURM_CPUS_PER_TASK" ]; then
  ntomp="$SLURM_CPUS_PER_TASK"
else
  ntomp="1"
fi

# Make sure to set OMP_NUM_THREADS equal to the value used for ntomp
# to avoid complaints from GROMACS
export OMP_NUM_THREADS=$ntomp
$MPIRUN $GMX mdrun $ntmpi -ntomp $ntomp -s MEM.tpr -nsteps 10000 -resethway



##### https://www.uppmax.uu.se/support/user-guides/gromacs-user-guide/