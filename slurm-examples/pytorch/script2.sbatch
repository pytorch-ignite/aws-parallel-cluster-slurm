#!/bin/bash
#SBATCH --job-name=script2
#SBATCH --output=slurm_%j.out
#SBATCH --ntasks=1
#SBATCH --time=00:05:00
#SBATCH --partition=cpu-compute-spot


date;hostname;pwd
source activate test
conda list | grep pytorch

echo "SLURM_JOB_ID: $SLURM_JOB_ID"
echo "SLURM_NNODES: $SLURM_NNODES"
echo "SLURM_NTASKS: $SLURM_NTASKS"
echo "SLURM_NTASKS_PER_NODE: $SLURM_NTASKS_PER_NODE"
echo "SLURM_LOCALID: $SLURM_LOCALID"

python check_pytorch.py
