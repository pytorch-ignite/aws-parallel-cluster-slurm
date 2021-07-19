#!/bin/sh -e

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
yes "yes" | bash miniconda.sh -b -p /shared/conda
. /shared/conda/bin/activate
conda init
conda deactivate
conda config --set auto_activate_base false
conda -V
rm miniconda.sh
