#!/bin/bash
#SBATCH -p barbun
#SBATCH -A hozdemir
#SBATCH -J 3o4l_TCRpMHC_250ns
#SBATCH -N 2
#SBATCH -n 40
#SBATCH --time=15-00:00:00
#SBATCH --mail-user=ozdemir.genetik@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err


module purge
source /truba/sw/centos7.9/comp/intel/oneapi-2021.2/setvars.sh
module load centos7.9/comp/cmake/3.18.0
module load centos7.9/comp/gcc/7
module load centos7.9/lib/cuda/11.4

# Automatic selection of ntomp argument based on "-c" (-c, --cpus-per-task=<ncpus>) argument to sbatch

if [ -n "$SLURM_CPUS_PER_TASK" ]; then
   ntomp="$SLURM_CPUS_PER_TASK"
else
   ntomp="1"
fi

echo $ntomp

export OMP_NUM_THREADS=$ntomp

echo "SLURM_NODELIST $SLURM_NODELIST"
echo "NUMBER OF CORES $SLURM_NTASKS"

GROMACS_DIR=/truba/sw/centos7.9/app/gromacs/2021.2-impi-mkl-oneapi-2021.2-GOLD/bin

# Run A Simulation
#mpirun $GROMACS_DIR/gmx_mpi mdrun $ntmpi -ntomp $ntomp -v -s 3o4l_TCRpMHC_250ns

# Continue A Simulation
mpirun $GROMACS_DIR/gmx_mpi mdrun $ntmpi -ntomp $ntomp -v -s 3o4l_TCRpMHC_250ns.tpr -cpi state.cpt -deffnm 3o4l_TCRpMHC_250ns
exit