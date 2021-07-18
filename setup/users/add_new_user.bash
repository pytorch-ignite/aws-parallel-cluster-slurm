#!/bin/bash

users_filepath="/shared/.userslist"

# Only take action if two arguments are provided and the second is a local file
if [ $# -eq 1 ] ; then
  USERNAME=$1
else
  echo "Usage: `basename $0` <user-name>"
  echo "<user-name> should be a user account"
  exit 1
fi

# Check if user does not exist:
if [ id "$USERNAME" &>/dev/null ] ; then
  echo "User $USERNAME exists. Please, add another user name"
  exit 1
fi

set -e

echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Please enter the public SSH key for the user: " >&2
read pub_key

# Create new user
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Create new user: $USERNAME" >&2
sudo useradd --create-home $USERNAME
sudo bash -c "echo \"$USERNAME `id -u $USERNAME`\" >> $users_filepath"
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Updated users list: $(sudo tail -1 $users_filepath)" >&2

# Create .ssh directory, set up the authorized_keys file
sudo mkdir /home/$USERNAME/.ssh
sudo bash -c "echo $pub_key > /home/$USERNAME/.ssh/authorized_keys"
sudo chmod 600 /home/$USERNAME/.ssh/authorized_keys
sudo chown $USERNAME:$USERNAME /home/$USERNAME/.ssh/authorized_keys

# Make the bash shell default for newuser
sudo usermod --shell /bin/bash $USERNAME

echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Added public key to /home/$USERNAME/.ssh/authorized_keys" >&2