#!/bin/bash
USERNAME=$1
if [ id "$USERNAME" &>/dev/null ] ; then
    echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] User $USERNAME exists"
    exit 1
fi