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
res=`cut -d : -f 1 /etc/passwd | grep $USERNAME`
if [ -n "$res" ] ; then
  echo "User $USERNAME exists. Please, add another user name"
  exit 1
fi

set -e

# Create new user
sudo useradd --create-home $USERNAME
sudo echo "$USERNAME `id -u $USERNAME`" >> $users_filepath

# Create .ssh directory, set up the authorized_keys file
sudo mkdir /home/$USERNAME/.ssh
sudo bash -c "cat $KEYFILE > /home/$USERNAME/.ssh/authorized_keys"
sudo chmod 600 /home/$USERNAME/.ssh/authorized_keys
