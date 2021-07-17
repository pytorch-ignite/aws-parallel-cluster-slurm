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
# for example list all users : cut -d: -f1 /etc/passwd

# Remove existing user
sudo userdel $USERNAME
# echo "newuser `id -u newuser`" >> /shared/.userslist

# # Create the user home and .ssh directory, set up the authorized_keys file
# # Note this will overwrite any existing keys if used multiple times
# mkhomedir_helper $USERNAME
# mkdir -p /home/$USERNAME/.ssh
# cat $KEYFILE > /home/$USERNAME/.ssh/authorized_keys
# chmod 600 /home/$USERNAME/.ssh/authorized_keys
# chown -R $USERNAME:users /home/$USERNAME