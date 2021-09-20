#!/bin/bash
#SBATCH --job-name=script5
#SBATCH --output=slurm_%j.out
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:05:00
#SBATCH --partition=gpu-compute-spot
#SBATCH --exclusive

set -e

srun -l hostname

srun -l echo "SLURM_JOB_ID: $SLURM_JOB_ID\n SLURM_NNODES: $SLURM_NNODES\n SLURM_NTASKS: $SLURM_NTASKS\n SLURM_NTASKS_PER_NODE: $SLURM_NTASKS_PER_NODE\n SLURM_LOCALID: $SLURM_LOCALID"
srun -l echo "WORLD_SIZE: $WORLD_SIZE\n RANK: $RANK\n LOCAL_RANK: $LOCAL_RANK"

srun python check_ddp_pytorch_gpu.py
