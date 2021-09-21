# Train resnet18 on CIFAR10 with SLURM

## Download the data

```
python -c "from torchvision.datasets import CIFAR10; CIFAR10('/shared/data/cifar10', download=True)"

ln -s /shared/data/cifar10 cifar10

mkdir -p /shared/output/$UID/output-cifar10
ln -s /shared/output/$UID/output-cifar10 output-cifar10
```

## Download the code

```
wget https://raw.githubusercontent.com/pytorch-ignite/examples/main/tutorials/cifar10-distributed.py
```