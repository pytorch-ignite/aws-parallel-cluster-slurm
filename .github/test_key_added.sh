#!/bin/bash
USERNAME=$1
KEY=$2
users_filepath="/shared/.userslist"
if [ ! grep "$KEY" /home/$USERNAME/.ssh/authorized_keys &>/dev/null] ; then
    echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] The key $KEY is not found in authorized keys for user $USERNAME"
    exit 1
fi