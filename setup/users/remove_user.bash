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
if [ ! id "$USERNAME" &>/dev/null ] ; then
    echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] User $USERNAME is not found"
    exit 1
fi

echo -n "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Please, confirm to remove user: $USERNAME [Y/n]: "
read confirm

if [ ! "$confirm" == "Y" ] ; then
  echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Canceled. Exiting ..."
  exit 1
fi

set -e

# Remove user from users list
sudo sed -i "/$USERNAME `id -u $USERNAME`/d" $users_filepath
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Removed $USERNAME from users list"
# Remove existing user and saving the backup
sudo mkdir -p /home/.backup/$USERNAME
sudo deluser --remove-home --backup-to /home/.backup/$USERNAME  $USERNAME
# The backup is saved as username.tar.bz2 file, so in the case of the user
# with the same username being deleted we rename the file to include the date
# and time of deletion
BACKUP_TIME=$(date '+%Y_%m_%d-%H_%M_%S')
OLD_BACKUP_NAME="$USERNAME.tar.bz2"
NEW_BACKUP_NAME="${USERNAME}_$BACKUP_TIME.tar.bz2"
sudo mv /home/.backup/$USERNAME/$OLD_BACKUP_NAME /home/.backup/$USERNAME/$NEW_BACKUP_NAME
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] $USERNAME backup saved to /home/.backup/$NEW_BACKUP_NAME"
echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] User $USERNAME was deleted"

