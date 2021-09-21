#!/bin/bash
#SBATCH --job-name=script3
#SBATCH --output=slurm_%j.out
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:05:00
#SBATCH --partition=gpu-compute-ondemand
#SBATCH --nodelist=gpu-compute-ondemand-dy-g4dnxlarge-1

set -e

cmd="pip install --upgrade git+https://github.com/pytorch/ignite.git && python check_idist.py --backend=nccl"

cname="/shared/enroot_data/pytorchignite+vision+latest.sqsh"

srun -l --container-name=ignite-vision --container-image=$cname --no-container-remap-root --container-workdir=$PWD bash -c "$cmd"
