# AWS Parallel Cluster (SLURM) setup and info

> AWS ParallelCluster is an AWS supported open source cluster management tool that helps you to deploy and manage high performance computing (HPC) clusters in the AWS Cloud. Built on the open source CfnCluster project, AWS ParallelCluster enables you to quickly build an HPC compute environment in AWS. It automatically sets up the required compute resources and shared filesystem. You can use AWS ParallelCluster with batch schedulers, such as AWS Batch and Slurm. AWS ParallelCluster facilitates quick start proof of concept deployments and production deployments. You can also build higher level workflows, such as a genomics portal that automates an entire DNA sequencing workflow, on top of AWS ParallelCluster.

- https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html

## Cluster Setup

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

In the command line:
```bash
aws ec2 create-key-pair --key-name playground-cluster --output text > ~/.ssh/aws-playground-cluster.pem
chmod 600 ~/.ssh/aws-playground-cluster.pem
```


### Configure AWS ParallelCluster
- https://docs.aws.amazon.com/parallelcluster/latest/ug/configuration.html
- https://docs.aws.amazon.com/parallelcluster/latest/ug/examples.html#example.slurm


- Testing cluster setup with configuration [configs/playground](configs/playground)
- Production cluster setup with configuration [configs/playground](configs/playground)


### Create a cluster

- [Testing cluster](playground_cluster.md)

#### Deep-Learning cluster

```bash
pcluster create aws-deeplearning-cluster -c configs/deeplearning
```

## User management

1. Connect to the cluster as admin user (`ubuntu` by default)
2. Clone `aws-parallel-cluster-slurm` repository:
```bash
git clone git@github.com:pytorch-ignite/aws-parallel-cluster-slurm.git
cd aws-parallel-cluster-slurm
```

### Add new user

3. Get SSH public key from the user
4. Execute the command to create user, e.g. `alice`:
```bash
bash setup/users/add_new_user.bash alice
>
[INFO][2021-07-17 21:19:26] Please enter the public SSH key for the user:
ssh-rsa AAAAB....
[INFO][2021-07-17 21:19:34] Create new user: alice
[INFO][2021-07-17 21:19:34] Updated users list: alice 1001
[INFO][2021-07-17 21:19:34] Added public key to /home/alice/.ssh/authorized_keys
```
5. Verify
```bash
id alice
>
uid=1001(alice) gid=1001(alice) groups=1001(alice)
```

User should be able to connect the cluster with SSH:
```
ssh -i /path/to/ssh/private/id_rsa alice@<cluster-ip>
```

### Remove existing user

3. Execute the command to remove user, e.g. `alice`:
```bash
bash setup/users/remove_user.bash alice
>
[INFO][2021-07-17 21:31:53] Please, confirm to remove user: alice [Y/n]: Y
[INFO][2021-07-17 21:31:55] Removed alice from users list
Looking for files to backup/remove ...
Removing files ...
Removing user `alice' ...
Warning: group `alice' has no more members.
Done.
[INFO][2021-07-17 21:31:55] User alice was deleted
```
4. Verify
```bash
id alice
>
id: ‘alice’: no such user
```


## Cluster usage

- https://slurm.schedmd.com/man_index.html

`srun`, `sbatch`, `sinfo`, `squeue`, `scancel`


## References

- https://docs.aws.amazon.com/parallelcluster/latest/ug/getting_started.html
- https://github.com/aws/aws-parallelcluster/wiki
- https://aws.amazon.com/blogs/opensource/managing-aws-parallelcluster-ssh-users-with-openldap/
- https://aws.amazon.com/blogs/opensource/aws-parallelcluster/
- https://sc20.hpcworkshops.com/09-ml-on-parallelcluster.html
- https://github.com/aws-samples/no-tears-cluster/blob/release/USER_GUIDE.md
- https://github.com/aws-samples/1click-hpc/tree/main/docs
- https://www.hpcworkshops.com/01-hpc-overview.html