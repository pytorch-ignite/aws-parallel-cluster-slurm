#!/bin/bash -e

users_filepath="/shared/.userslist"

# Only take action if two arguments are provided and the second is a local file
if [ $# -eq 1 ] ; then
  USERNAME=$1
else
  echo "Usage: `basename $0` <user-name>"
  echo "<user-name> should be a user account"
  exit 1
fi

# Need to check if user exists:
if ! id "$USERNAME" &>/dev/null; then
    echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] User $USERNAME is not found"
    exit 1
fi


# Remove user from users list
sudo sed -i "/$USERNAME `id -u $USERNAME`/d" $users_filepath
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Removed $USERNAME from users list"
# Remove existing user
sudo deluser --remove-home $USERNAME
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] User $USERNAME was deleted"
