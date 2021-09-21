#!/bin/bash
#SBATCH --job-name=script3
#SBATCH --output=slurm_%j.out
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:05:00
#SBATCH --partition=cpu-compute-spot

set -e

srun hostname

srun -l bash -c 'echo "SLURM_JOB_ID: $SLURM_JOB_ID"'
srun -l bash -c 'echo "SLURM_NNODES: $SLURM_NNODES"'
srun -l bash -c 'echo "SLURM_NTASKS: $SLURM_NTASKS"'
srun -l bash -c 'echo "SLURM_NTASKS_PER_NODE: $SLURM_NTASKS_PER_NODE"'
srun -l bash -c 'echo "SLURM_LOCALID: $SLURM_LOCALID"'
srun -l bash -c 'echo "SLURM_PROCID: $SLURM_PROCID"'
srun -l bash -c 'echo "SLURM_STEP_TASKS_PER_NODE: $SLURM_STEP_TASKS_PER_NODE"'

# srun -l python --version
srun -l python check_ddp_pytorch.py
