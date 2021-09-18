#!/bin/bash -e

. "/etc/parallelcluster/cfnconfig"

users_filepath="/shared/.userslist"
enroot_dir="/shared/enroot"
pyxis_dir="/shared/pyxis"


echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] post_install.bash START" >&2

if [ "${cfn_node_type}" = "MasterServer" ]; then

    echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] MasterServer: Create empty users list file: $users_filepath" >&2
    touch $users_filepath
    chmod 600 $users_filepath
    # >
    # -rw-------  1 root root    0 Jul 18 00:13 .userslist

    # Create storage for docker images
    if docker --version &> /dev/null; then
        mkdir -p /shared/docker
    fi
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

if ! docker --version &> /dev/null; then
    exit 0
fi

#Install enroot
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Installing enroot" >&2
if [ "${cfn_node_type}" = "MasterServer" ]; then
    git clone --recurse-submodules https://github.com/NVIDIA/enroot.git $enroot_dir
    sudo mkdir /shared/enroot_data
    sudo chmod 1777 /shared/enroot_data
    sudo mkdir /shared/enroot_cache
    sudo chmod 1777 /shared/enroot_cache
fi
sudo apt-get -y update && sudo apt-get install zstd
sudo apt install -y git gcc make libcap2-bin libtool automake
sudo apt install -y curl gawk jq squashfs-tools parallel
sudo apt install -y fuse-overlayfs libnvidia-container-tools pigz squashfuse # optional
sudo make --directory=$enroot_dir install
sudo make --directory=$enroot_dir setcap
sudo mkdir /tmp/enroot
sudo chmod 1777 /tmp/enroot
sudo mkdir /etc/enroot
sudo sed -i 's/\#ENROOT_RUNTIME_PATH        \${XDG_RUNTIME_DIR}\/enroot/ENROOT_RUNTIME_PATH        \/tmp\/enroot\/\${UID}/g' /usr/local/etc/enroot/enroot.conf
sudo sed -i 's/\#ENROOT_DATA_PATH        \${XDG_DATA_HOME}\/enroot/ENROOT_DATA_PATH        \/share\/enroot_data\/\${UID}/g' /usr/local/etc/enroot/enroot.conf
sudo sed -i 's/\#ENROOT_CACHE_PATH        \${XDG_CACHE_HOME}\/enroot/ENROOT_CACHE_PATH        \/share\/enroot_cache\/\${UID}/g' /usr/local/etc/enroot/enroot.conf


# Installing pyxis
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Installing pyxis" >&2
if [ "${cfn_node_type}" = "MasterServer" ]; then
    git clone https://github.com/NVIDIA/pyxis.git $pyxis_dir
fi
sudo ln -s /opt/slurm/include/slurm /usr/include/slurm
sudo make --directory=$pyxis_dir install
sudo touch /opt/slurm/etc/plugstack.conf
sudo mkdir /tmp/pyxis
sudo chmod 1777 /tmp/pyxis
sudo bash -c "echo 'required /usr/local/lib/slurm/spank_pyxis.so runtime_path=/tmp/pyxis' > /opt/slurm/etc/plugstack.conf"

echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] post_install.bash: STOP" >&2