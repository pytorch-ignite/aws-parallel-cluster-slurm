### Testing cluster

0. Make sure to upload `post_install.bash` script to S3
```bash
aws s3 cp setup/playground/post_install.bash s3://aws-parallel-cluster-slurm/playground/post_install.bash
```

- https://s3.console.aws.amazon.com/s3/buckets/aws-parallel-cluster-slurm?region=us-east-2

1. Create cluster:

```bash
pcluster create aws-playground-cluster -c configs/playground

pcluster status aws-playground-cluster -c configs/playground
```

If cluster creation is failed, try with "no rollback" option:
```bash
pcluster create aws-playground-cluster -c configs/playground --norollback
```
Then you can use ssh to connect to the head node and check `/var/log/chef-client.log`,
which should confirm where the creation is stuck on or `/var/log/parallelcluster/clustermgtd`
that contains the reason why capacity cannot be provisioned"

- https://docs.aws.amazon.com/parallelcluster/latest/ug/troubleshooting.html#retrieving-and-preserve-logs

1.1 Check connection to the head node
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
PARTITION             AVAIL  TIMELIMIT  NODES  STATE NODELIST
cpu-compute-spot         up   infinite      4  idle~ cpu-compute-spot-dy-t3micro-[1-4]
gpu-compute-on-demand    up   infinite      4  idle~ gpu-compute-on-demand-dy-g4dnxlarge-[1-4]
gpu-compute-spot*        up   infinite      4  idle~ gpu-compute-spot-dy-g4dnxlarge-[1-4]

hostname
>
ip-172-31-10-217

srun -N 2 -n 2 -l --partition=cpu-compute-spot hostname
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

Connect to the cluster. To enable access to `aws-parallel-cluster-slurm` repository,
add `id_rsa.pub` to project's deploy keys: https://github.com/pytorch-ignite/aws-parallel-cluster-slurm/settings/keys .
Clone the repository:
```bash
git clone git@github.com:pytorch-ignite/aws-parallel-cluster-slurm.git
cd aws-parallel-cluster-slurm/setup/playground/
sh install_miniconda.sh

source ~/.bashrc
conda env list
```

```bash
conda create -y -n test
conda activate test
conda install -y  pytorch cpuonly -c pytorch
srun -N 2 -l --partition=cpu-compute-spot conda env list
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

#### Cluster AWS dashboard

- https://us-east-2.console.aws.amazon.com/cloudwatch/home?region=us-east-2#dashboards:name=parallelcluster-aws-playground-cluster-us-east-2

#### Update cluster

To modify configuration and apply it to the existing cluster:

```bash
pcluster stop aws-playground-cluster -c configs/playground

pcluster update aws-playground-cluster -c configs/playground

...

pcluster start aws-playground-cluster -c configs/playground

pcluster status aws-playground-cluster -c configs/playground
```

#### GPU examples

1. Setup conda environment

Connect to the cluster and execute:
```bash
conda env list

conda create -y -n test-gpu
conda activate test-gpu
conda install -y pytorch torchvision cudatoolkit=11.1 -c pytorch -c nvidia
```

2. Submit GPU job

```bash
conda activate test-gpu
cd slurm-examples
sbatch script5.sbatch
squeue
```

#### Using Docker images

1. Submit a CPU job using docker images:
```bash
srun --partition=cpu-compute-spot --container-image=ubuntu:latest grep PRETTY /etc/os-release
>
pyxis: importing docker image ...
PRETTY_NAME="Ubuntu 20.04.3 LTS"
```
or
```bash
srun -N 2 -l --partition=cpu-compute-spot --container-image=ubuntu:latest grep PRETTY /etc/os-release
>
1: pyxis: importing docker image ...
0: pyxis: importing docker image ...
1: PRETTY_NAME="Ubuntu 20.04.3 LTS"
0: PRETTY_NAME="Ubuntu 20.04.3 LTS"
```

2. Submit a CPU job using `pytorchignite/base:latest` docker image and `sbatch`

2.1 Import docker image in `sqsh` format:

```bash
enroot import -o /shared/enroot_data/pytorchignite+vision+latest.sqsh docker://pytorchignite/vision:latest
```

2.2 Execute a command from the container:

```bash
SLURM_DEBUG=2 srun --partition=gpu-compute-ondemand -w gpu-compute-ondemand-dy-g4dnxlarge-1 --container-name=ignite-vision --container-image=/shared/enroot_data/pytorchignite+vision+latest.sqsh pip list | grep torch

SLURM_DEBUG=2 srun --partition=gpu-compute-ondemand -w gpu-compute-ondemand-dy-g4dnxlarge-1 --container-name=ignite-vision --container-image=/shared/enroot_data/pytorchignite+vision+latest.sqsh echo "$WORLD_SIZE:$RANK:$LOCAL_RANK:$MASTER_ADDR:$MASTER_PORT"

SLURM_DEBUG=2 srun --partition=gpu-compute-ondemand -w gpu-compute-ondemand-dy-g4dnxlarge-1 --container-name=ignite-vision --container-image=/shared/enroot_data/pytorchignite+vision+latest.sqsh python -c "import os; print(os.environ)"
```

#### Remove existing cluster

```bash
pcluster delete aws-playground-cluster -c configs/playground
```


### Enroot and srun commands:

```bash
enroot import docker://python:latest

enroot start --mount $PWD:/ws python+latest.sqsh /bin/bash
```

- https://github.com/NVIDIA/enroot/blob/master/doc/usage.md


Debug enroot configuration from a worker node:
```bash
srun --partition=cpu-compute-spot --pty bash
srun --partition=cpu-compute-spot --container-image=ubuntu:latest --pty bash
srun --partition=cpu-compute-spot --container-image=python:3.9-alpine --pty ash


SLURM_DEBUG=2 srun --partition=gpu-compute-spot -w gpu-compute-spot-dy-g4dnxlarge-1 --pty bash

SLURM_DEBUG=2 srun --partition=gpu-compute-ondemand -w gpu-compute-ondemand-dy-g4dnxlarge-1 --pty bash

enroot start /shared/enroot_data/pytorchignite+vision+latest.sqsh /bin/bash

SLURM_DEBUG=2 NVIDIA_VISIBLE_DEVICES= srun --partition=cpu-compute-spot --container-name=ignite-vision --container-image=/shared/enroot_data/pytorchignite+vision+latest.sqsh pip list | grep torch

```

Enable PyTorch hook:
```
sudo cp /usr/local/share/enroot/hooks.d/50-slurm-pytorch.sh /usr/local/etc/enroot/hooks.d/
```

WEIRD SPOT INSTANCE ERROR MESSAGE
```
1632138698570
@log
201193730185:/aws/parallelcluster/aws-playground-cluster
@logStream
ip-10-0-0-179.i-073d7e1c2820a64e5.slurm_resume
@message
2021-09-20 11:51:36,615 - [slurm_plugin.common:add_instances_for_nodes] - ERROR - Encountered exception when launching instances for nodes (x1) ['gpu-compute-spot-dy-g4dnxlarge-1']: An error occurred (InsufficientInstanceCapacity) when calling the RunInstances operation (reached max retries: 1): There is no Spot capacity available that matches your request.
@timestamp
1632138696615
```