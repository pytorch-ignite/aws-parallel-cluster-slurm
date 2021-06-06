#### Testing cluster

```bash
pcluster create aws-playground-cluster -c configs/playground
```

1. Check connection to the head node
```bash
pcluster ssh aws-playground-cluster -i ~/.ssh/aws-playground-cluster.pem
```

2. Check cluster

Connect to the cluster and execute:
```bash
which sinfo
>
/opt/slurm/bin/sinfo

sinfo
>
PARTITION         AVAIL  TIMELIMIT  NODES  STATE NODELIST
compute-on-demand    up   infinite      4  idle~ compute-on-demand-dy-t3micro-[1-4]
compute-spot*        up   infinite      4  idle~ compute-spot-dy-t3micro-[1-4]

hostname
>
ip-10-0-0-148

srun -N 2 -n 2 -l hostname
>
0: compute-spot-dy-t3micro-1
1: compute-spot-dy-t3micro-2
```


3. Setup conda environment

Connect to the cluster and execute:
```bash
cd /code
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh
bash Miniconda3-py39_4.9.2-Linux-x86_64.sh
...

conda init bash
source ~/.bashrc
conda env list
```

```bash
conda create -n test
conda install pytorch cpuonly -c pytorch
conda activate test
srun -N 2 -l conda env list
>
1: # conda environments:
1: #
1: base                     /code/miniconda3
1: test                  *  /code/miniconda3/envs/test
1:
0: # conda environments:
0: #
0: base                     /code/miniconda3
0: test                  *  /code/miniconda3/envs/test
0:
```

4. Examples

Connect to the cluster and activate "test" environment:
```bash
conda activate test
cd slurm-examples
sbatch script1.bash
squeue
```