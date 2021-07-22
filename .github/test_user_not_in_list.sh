#!/bin/bash
USERNAME=$1
users_filepath="/shared/.userslist"
if [ grep "$USERNAME" users_filepath &>/dev/null ] ; then
    echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] The user $USERNAME is found in $users_filepath"
    exit 1
fi