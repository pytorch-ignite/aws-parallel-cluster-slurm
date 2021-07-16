#!/bin/bash
#SBATCH --job-name=script1
#SBATCH --output=slurm_%j.out
#SBATCH --ntasks=1
#SBATCH --time=00:01:00
#SBATCH --nodelist=compute-spot-dy-t3micro-1

date;hostname;pwd

conda env list
which python
python --version
conda list

python -c "import torch; print(torch.__version__)"

date