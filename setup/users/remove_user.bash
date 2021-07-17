#!/bin/bash -e

# Only take action if two arguments are provided and the second is a local file
if [ $# -eq 1 ] ; then
  USERNAME=$1
else
  echo "Usage: `basename $0` <user-name>"
  echo "<user-name> should be a user account"
  exit 1
fi

# Need to check if user exists:
if id "$USERNAME" &>/dev/null; then
    echo 'User found'
else
    echo 'User not found'
    exit 1
fi

# Remove existing user
sudo deluser --remove-home $USERNAME
# Remove user from .userslist
sudo sed -i '/$USERNAME `id -u $USERNAME/d' /shared/.userslist