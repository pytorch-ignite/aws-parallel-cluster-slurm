### Testing cluster

```bash
pcluster create aws-playground-cluster -c configs/playground

pcluster status -c configs/playground aws-playground-cluster
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

2.1 Module Environment

- https://www.hpcworkshops.com/03-hpc-aws-parallelcluster-workshop/07-logon-pc.html

List available modules (below command can be unavailable):

```bash
module av
>
---------------------------------------------------------------- /usr/share/modules/modulefiles -----------------------------------------------------------------
dot  libfabric-aws/1.11.2amzn1.1  module-git  module-info  modules  null  openmpi/4.1.1  use.own

---------------------------------------------------------------- /usr/share/modules/modulefiles -----------------------------------------------------------------
dot  libfabric-aws/1.11.2amzn1.1  module-git  module-info  modules  null  openmpi/4.1.1  use.own

-------------------------------------------------------- /opt/intel/impi/2019.8.254/intel64/modulefiles ---------------------------------------------------------
intelmpi
```

2.2 NFS Shares

List mounted volumes:

```bash
showmount -e localhost
>
Export list for localhost:
/opt/slurm 10.0.0.0/16
/opt/intel 10.0.0.0/16
/home      10.0.0.0/16
/shared    10.0.0.0/16
```


3. Setup conda environment

Connect to the cluster and execute:
```bash
git clone git@github.com:pytorch-ignite/aws-parallel-cluster-slurm.git
cd aws-parallel-cluster-slurm/setup/playground/
sh install_miniconda.sh

source ~/.bashrc
conda env list
```

```bash
conda create -n -y test
conda activate test
conda install -y  pytorch cpuonly -c pytorch
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
sbatch script1.sbatch
squeue
```

#### Update cluster

To modify configuration and apply it to the existing cluster:

```bash
pcluster stop -c configs/playground aws-playground-cluster

pcluster update -c configs/playground aws-playground-cluster

...

pcluster start -c configs/playground aws-playground-cluster

pcluster status -c configs/playground aws-playground-cluster
```

#### GPU examples

1. Setup conda environment

Connect to the cluster and execute:
```bash
conda env list

conda create -n -y test-gpu
conda activate test-gpu
conda install -y pytorch torchvision cudatoolkit=11.1 -c pytorch -c nvidia
```

2.


#### Remove existing cluster

```
pcluster delete -c configs/playground aws-playground-cluster
```