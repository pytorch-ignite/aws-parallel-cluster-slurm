#!/bin/bash
#SBATCH --job-name=script3
#SBATCH --output=slurm_%j.out
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --time=00:05:00
#SBATCH --partition=cpu-compute-spot

set -e

cmd="pip install --upgrade git+https://github.com/pytorch/ignite.git && python check_idist.py --backend=gloo"

cname="/shared/enroot_data/pytorchignite+vision+latest.sqsh"

NVIDIA_VISIBLE_DEVICES="" srun -l --container-name=ignite-vision --container-image=$cname --no-container-remap-root --container-workdir=$PWD bash -c "$cmd"
