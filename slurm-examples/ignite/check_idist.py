import os
import argparse
import time

import ignite
import ignite.distributed as idist


def main_fn(_):

    rank = idist.get_rank()
    time.sleep(0.1 * rank)
    print(rank, f"ignite version: {ignite.__version__}")

    addr = f"{os.environ['MASTER_ADDR']}:{os.environ['MASTER_PORT']}"
    time.sleep(0.1 * rank)
    print(f"[{addr}], [{idist.backend()}], process {idist.get_rank()}/{idist.get_world_size()}")
    idist.barrier()


if __name__ == "__main__":

    parser = argparse.ArgumentParser("idist main script")
    parser.add_argument("--backend", type=str, default="nccl")
    args = parser.parse_args()

    with idist.Parallel(backend=args.backend) as parallel:
        parallel.run(main_fn)