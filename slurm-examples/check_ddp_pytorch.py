import os
import subprocess
import time
import torch
import torch.distributed as dist


def pprint(msg):
    time.sleep(dist.get_rank() * 0.01)
    print(dist.get_rank(), msg)


if __name__ == "__main__":

    for k in ["SLURM_JOB_ID", "SLURM_PROCID", "SLURM_LOCALID", "SLURM_NTASKS", "SLURM_JOB_NODELIST"]:
        if k not in os.environ:
            raise RuntimeError(f"SLURM distributed configuration is missing '{k}' in env variables")

    os.environ["RANK"] = os.environ["SLURM_PROCID"]
    os.environ["LOCAL_RANK"] = os.environ["SLURM_LOCALID"]
    os.environ["WORLD_SIZE"] = os.environ["SLURM_NTASKS"]
    # port should be the same over all process
    slurm_port = os.environ["SLURM_JOB_ID"]
    slurm_port = slurm_port[-4:]
    os.environ["MASTER_PORT"] = str(int(slurm_port) + 15000)
    try:
        # master address is the first hostname of nodes list
        hostnames = subprocess.check_output(["scontrol", "show", "hostnames", os.environ["SLURM_JOB_NODELIST"]])
    except FileNotFoundError as e:
        # restore the environment before raising the exception
        raise e
    os.environ["MASTER_ADDR"] = hostnames.split()[0].decode("utf-8")

    # print env per rank
    time.sleep(int(os.environ["RANK"]) * 0.1)
    print("---")
    print("MASTER_PORT", os.environ["MASTER_PORT"])
    print("MASTER_ADDR", os.environ["MASTER_ADDR"])
    print("WORLD_SIZE", os.environ["WORLD_SIZE"])
    print("RANK", os.environ["RANK"])
    print("LOCAL_RANK", os.environ["LOCAL_RANK"])
    print("---")

    time.sleep(5)

    dist.init_process_group(backend='gloo', init_method='env://')

    pprint(dist.get_world_size())
    t = torch.ones(5) * dist.get_rank()
    pprint(t)
    dist.all_reduce(t)
    pprint(t)

    dist.destroy_process_group()