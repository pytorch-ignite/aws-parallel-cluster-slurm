#!/bin/bash -e

. "/etc/parallelcluster/cfnconfig"

users_filepath="/shared/.userslist"

echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] post.install.sh START" >&2

if [ "${cfn_node_type}" = "MasterServer" ]; then

    echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] MasterServer: Create empty users list file: $users_filepath" >&2
    touch $users_filepath
    sudo chmod 600 $users_filepath

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

echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] post.install.sh: STOP" >&2