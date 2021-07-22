#!/bin/bash -e

script_folder="`dirname $0`"

# Only take action if two arguments are provided and the second is a local file
if [ $# -eq 1 ] ; then
  USERNAME=$1
else
  echo "Usage: `basename $0` <user-name>"
  echo "<user-name> should be a user account"
  exit 1
fi

# Need to check if user exists:
if ! id "$USERNAME" &>/dev/null ; then
    echo "[ERROR][$(date '+%Y-%m-%d %H:%M:%S')] User $USERNAME is not found"
    exit 1
fi

echo -n "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Please, confirm to remove user: $USERNAME [Y/n]: "
read confirm

if ! [ "$confirm" == "Y" ] ; then
  echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Canceled. Exiting ..."
  exit 1
fi

set -e

# Set up env variables
source $script_folder/env.bash

# Remove user from users list
sudo sed -i "/$USERNAME `id -u $USERNAME`/d" $users_filepath
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Removed $USERNAME from users list"

# Remove existing user and saving the backup
backup_folder="$home_dir/.backup/$USERNAME/$(date '+%Y_%m_%d-%H_%M_%S')"
sudo mkdir -p $backup_folder
sudo deluser --remove-home --backup-to $backup_folder $USERNAME

echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] $USERNAME backup saved to $backup_folder"
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] User $USERNAME was deleted"
