#!/bin/bash
#SBATCH --job-name=cifar10-cpu
#SBATCH --output=slurm_%j.out
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --time=00:05:00
#SBATCH --partition=cpu-compute-spot

set -e

cmd="pip install --upgrade git+https://github.com/pytorch/ignite.git && python cifar10-distributed.py run --backend=gloo"

cname="/shared/enroot_data/pytorchignite+vision+latest.sqsh"

NVIDIA_VISIBLE_DEVICES="" srun -l --container-name=ignite-vision --container-image=$cname --container-workdir=$PWD --no-container-remap-root bash -c "$cmd"
