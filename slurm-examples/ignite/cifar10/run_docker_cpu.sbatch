#!/bin/bash
#SBATCH --job-name=cifar10
#SBATCH --output=slurm_%j.out
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --time=00:05:00
#SBATCH --partition=cpu-compute-spot

set -e

# cmd="pip install --upgrade git+https://github.com/pytorch/ignite.git && python cifar10-distributed.py run --backend=nccl --data_path=/shared/data/cifar10 --output_path=/shared/output/$UID/output-cifar10"
# cname="/shared/enroot_data/pytorchignite+vision+latest.sqsh"
# srun -l --container-name=ignite-vision --container-image=$cname --container-workdir=$PWD bash -c "$cmd"

#cmd="pip install --upgrade git+https://github.com/pytorch/ignite.git && python cifar10-distributed.py run --backend=nccl --data_path=/shared/data/cifar10 --output_path=/shared/output/$UID/output-cifar10"

cmd="pip install --upgrade git+https://github.com/pytorch/ignite.git && python cifar10-distributed.py run --backend=gloo"

cname="/shared/enroot_data/pytorchignite+vision+latest.sqsh"

NVIDIA_VISIBLE_DEVICES="" srun -l --container-name=ignite-vision --container-image=$cname --no-container-remap-root --container-workdir=$PWD bash -c "$cmd"
