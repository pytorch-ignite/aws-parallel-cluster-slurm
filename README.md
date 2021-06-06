# AWS Parallel Cluster (SLURM) setup and info

> AWS ParallelCluster is an AWS supported open source cluster management tool that helps you to deploy and manage high performance computing (HPC) clusters in the AWS Cloud. Built on the open source CfnCluster project, AWS ParallelCluster enables you to quickly build an HPC compute environment in AWS. It automatically sets up the required compute resources and shared filesystem. You can use AWS ParallelCluster with batch schedulers, such as AWS Batch and Slurm. AWS ParallelCluster facilitates quick start proof of concept deployments and production deployments. You can also build higher level workflows, such as a genomics portal that automates an entire DNA sequencing workflow, on top of AWS ParallelCluster.

- https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html

## Cluster Setup

- https://docs.aws.amazon.com/parallelcluster/latest/ug/getting_started.html
- https://github.com/aws/aws-parallelcluster/wiki
- https://aws.amazon.com/blogs/opensource/managing-aws-parallelcluster-ssh-users-with-openldap/
- https://aws.amazon.com/blogs/opensource/aws-parallelcluster/


### Requirements


1. Install `aws-parallelcluster` python package
```bash
pip install aws-parallelcluster
pcluster version
> 2.10.4
```

2. AWS CLI:
```bash
pip install awscli

which aws
aws --version
> aws-cli/1.19.88 Python/3.8.10 Darwin/18.7.0 botocore/1.20.88
```

- https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html
```bash
aws configure
```

3. Create PEM identity file on AWS console
- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html


### Configure AWS ParallelCluster
- https://docs.aws.amazon.com/parallelcluster/latest/ug/configuration.html
- https://docs.aws.amazon.com/parallelcluster/latest/ug/examples.html#example.slurm


- Testing cluster setup with configuration [configs/playground](configs/playground)
- Production cluster setup with configuration [configs/playground](configs/playground)


### Create a cluster

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


#### Deep-Learning cluster

```bash
pcluster create aws-deeplearning-cluster -c configs/deeplearning
```

## Cluster usage

- https://slurm.schedmd.com/man_index.html

`srun`, `sbatch`, `sinfo`, `squeue`, `scancel`
