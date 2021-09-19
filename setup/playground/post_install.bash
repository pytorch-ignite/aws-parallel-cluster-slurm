#!/bin/bash -e

. "/etc/parallelcluster/cfnconfig"

users_filepath="/shared/.userslist"


echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] post_install.bash START" >&2

if [ "${cfn_node_type}" = "MasterServer" ]; then

    echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] MasterServer: Create empty users list file: $users_filepath" >&2
    touch $users_filepath
    chmod 600 $users_filepath
    # >
    # -rw-------  1 root root    0 Jul 18 00:13 .userslist

    # Create storage for docker images
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


#Install enroot
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Creating enroot directories" >&2
if [ "${cfn_node_type}" = "MasterServer" ]; then
    sudo mkdir /shared/enroot_data
    sudo chmod 1777 /shared/enroot_data
    sudo mkdir /shared/enroot_cache
    sudo chmod 1777 /shared/enroot_cache
    sudo mkdir /shared/enroot_runtime
    sudo chmod 1777 /shared/enroot_runtime
fi

sudo touch /opt/slurm/etc/plugstack.conf
sudo bash -c "echo 'required /usr/local/lib/slurm/spank_pyxis.so runtime_path=/tmp/pyxis' > /opt/slurm/etc/plugstack.conf"
sudo sed -i 's!#ENROOT_RUNTIME_PATH        ${XDG_RUNTIME_DIR}/enroot!ENROOT_RUNTIME_PATH        /shared/enroot_runtime/${UID}!g' /usr/local/etc/enroot/enroot.conf
sudo sed -i 's!#ENROOT_DATA_PATH           ${XDG_DATA_HOME}/enroot!ENROOT_DATA_PATH        /shared/enroot_data/${UID}!g' /usr/local/etc/enroot/enroot.conf
sudo sed -i 's!#ENROOT_CACHE_PATH          ${XDG_CACHE_HOME}/enroot!ENROOT_CACHE_PATH        /shared/enroot_cache/${UID}!g' /usr/local/etc/enroot/enroot.conf

echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] post_install.bash: STOP" >&2