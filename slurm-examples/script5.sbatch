#!/bin/bash
#SBATCH --job-name=script5
#SBATCH --output=slurm_%j.out
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:05:00
#SBATCH --partition=gpu-compute-spot
#SBATCH --exclusive

set -e

srun hostname

srun echo "SLURM_JOB_ID: $SLURM_JOB_ID"
srun echo "SLURM_NNODES: $SLURM_NNODES"
srun echo "SLURM_NTASKS: $SLURM_NTASKS"
srun echo "SLURM_NTASKS_PER_NODE: $SLURM_NTASKS_PER_NODE"
srun echo "SLURM_LOCALID: $SLURM_LOCALID"

srun python check_ddp_pytorch_gpu.py
