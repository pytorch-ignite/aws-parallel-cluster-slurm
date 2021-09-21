#!/bin/bash
#SBATCH --job-name=script2
#SBATCH --output=slurm_%j.out
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:05:00
#SBATCH --partition=gpu-compute-ondemand
#SBATCH --nodelist=gpu-compute-ondemand-dy-g4dnxlarge-1

set -e

srun python check_idist.py --backend=nccl
