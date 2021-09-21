#!/bin/bash
#SBATCH --job-name=cifar10
#SBATCH --output=slurm_%j.out
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:05:00
#SBATCH --partition=gpu-compute-ondemand
#SBATCH --nodelist=gpu-compute-ondemand-dy-g4dnxlarge-1

set -e

srun python cifar10-distributed.py run --backend=nccl
