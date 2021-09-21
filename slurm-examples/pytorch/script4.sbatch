#!/bin/bash
#SBATCH --job-name=script4
#SBATCH --output=slurm_%j.out
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:05:00
#SBATCH --partition=cpu-compute-spot

set -e

srun hostname
srun ls /home/ubuntu/.bashrc
srun conda env list
srun python -c "import torch; print(torch.__version__)"
