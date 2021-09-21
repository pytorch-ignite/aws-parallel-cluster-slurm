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

srun python check_ddp_pytorch_gpu.py
