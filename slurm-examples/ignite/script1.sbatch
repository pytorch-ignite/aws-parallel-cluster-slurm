#!/bin/bash
#SBATCH --job-name=script1
#SBATCH --output=slurm_%j.out
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:05:00
#SBATCH --partition=cpu-compute-spot

set -e

srun python check_idist.py --backend=gloo
