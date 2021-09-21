#!/bin/bash
#SBATCH --job-name=script3
#SBATCH --output=slurm_%j.out
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:05:00
#SBATCH --partition=gpu-compute-spot
#SBATCH --nodelist=gpu-compute-spot-dy-g4dnxlarge-1

set -e

# srun -l --container-name=ignite-vision --container-image=/shared/enroot_data/pytorchignite+vision+latest.sqsh bash -c "pip install --upgrade git+https://github.com/pytorch/ignite.git && cd ~/aws-parallel-cluster-slurm/slurm-examples/ignite && python check_idist.py --backend=nccl"

srun -l --container-name=ignite-vision --container-image=/shared/enroot_data/pytorchignite+vision+latest.sqsh python --version
