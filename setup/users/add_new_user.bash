#!/bin/bash

users_filepath="/shared/.userslist"

# Only take action if two arguments are provided and the second is a local file
if [ $# -eq 2 ] && [ -f "$2" ] ; then
  USERNAME=$1
  KEYFILE=$2
else
  echo "Usage: `basename $0` <user-name> <key-file>"
  echo "<user-name> should be a user account"
  echo "<key-file> should be an SSH public key file"
  exit 1
fi

# Check if user does not exist:
if id "$USERNAME" &>/dev/null; then
  echo "User $USERNAME exists. Please, add another user name"
  exit 1
fi

set -e

# Create new user
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Create new user: $USERNAME" >&2
sudo useradd --create-home $USERNAME
sudo echo "$USERNAME `id -u $USERNAME`" >> $users_filepath
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Updated users list: $(tail -1 $users_filepath)" >&2

# Create .ssh directory, set up the authorized_keys file
sudo mkdir /home/$USERNAME/.ssh
sudo bash -c "cat $KEYFILE > /home/$USERNAME/.ssh/authorized_keys"
sudo chmod 600 /home/$USERNAME/.ssh/authorized_keys

echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Added public key to /home/$USERNAME/.ssh/authorized_keys" >&2