#!/bin/bash -e

. "/etc/parallelcluster/cfnconfig"

shared_dir="/shared"
users_filepath="$shared_dir/.userslist"

echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] post_install.bash START" >&2

if [ "${cfn_node_type}" = "MasterServer" ]; then

    echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] MasterServer: Create empty users list file: $users_filepath" >&2
    touch $users_filepath
    chmod 600 $users_filepath
    # >
    # -rw-------  1 root root    0 Jul 18 00:13 .userslist
fi

if [ "${cfn_node_type}" = "ComputeFleet" ]; then

    echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] ComputeFleet: Set up users from users list: $users_filepath" >&2
    while read USERNAME USERID
    do
        # -M do not create home since head node is exporting /homes via NFS
        # -u to set UID to match what is set on the head node
        if ! [ $(id -u $USERNAME 2>/dev/null || echo -1) -ge 0 ]; then
            useradd -M -u $USERID $USERNAME
        fi
    done < $users_filepath

fi


# Enroot configuration
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Creating enroot directories" >&2

sudo touch /opt/slurm/etc/plugstack.conf
sudo bash -c "echo 'required /usr/local/lib/slurm/spank_pyxis.so runtime_path=/tmp/pyxis' > /opt/slurm/etc/plugstack.conf"

# https://github.com/NVIDIA/pyxis/wiki/Setup#enroot-configuration-example
# Let's configure only cache folder on shared:
sudo bash -c "echo 'ENROOT_CACHE_DIR=$shared_dir/enroot_cache' >> /etc/environment"

echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] post_install.bash: STOP" >&2