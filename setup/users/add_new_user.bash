#!/bin/bash

script_folder="`dirname $0`"

if [ $# -eq 1 ] ; then
  USERNAME=$1
else
  echo "Usage: `basename $0` <user-name>"
  echo "<user-name> should be a user account"
  exit 1
fi

# Check if user does not exist:
if id "$USERNAME" &>/dev/null ; then
  echo "[ERROR][$(date '+%Y-%m-%d %H:%M:%S')] User $USERNAME exists. Please, add another user name." >&2
  exit 1
fi

set -e

# Set up env variables
source $script_folder/env.bash

echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Please enter the public SSH key for the user: " >&2
read pub_key

# Create new user
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Create new user: $USERNAME" >&2
mkdir -p $home_dir
sudo useradd --create-home --home-dir $home_dir/$USERNAME $USERNAME
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] - new user: $USERNAME" >&2
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] - user's home dir: $home_dir/$USERNAME" >&2

sudo bash -c "echo \"$USERNAME `id -u $USERNAME`\" >> $users_filepath"
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Updated users list: $(sudo tail -1 $users_filepath)" >&2

# Create .ssh directory, set up the authorized_keys file
sudo mkdir $home_dir/$USERNAME/.ssh
sudo bash -c "echo $pub_key > $home_dir/$USERNAME/.ssh/authorized_keys"
sudo chmod 600 $home_dir/$USERNAME/.ssh/authorized_keys
sudo chown $USERNAME:$USERNAME $home_dir/$USERNAME/.ssh/authorized_keys
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Added public key to $home_dir/$USERNAME/.ssh/authorized_keys" >&2

# Make the bash shell default for newuser
sudo usermod --shell /bin/bash $USERNAME
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Set bash as default shell" >&2

conda_path=`true | which conda`
if [ -f "$conda_path" ] ; then
    sudo bash $script_folder/add_conda_init.bash $USERNAME
    echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Added conda initialization to .bashrc" >&2
fi

docker_path=`true | which docker`
if [ -f "$docker_path" ] ; then
    sudo usermod -aG docker $USERNAME
    echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Added user to docker group" >&2
fi
