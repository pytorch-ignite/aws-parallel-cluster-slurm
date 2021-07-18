#!/bin/bash

if [ $# -eq 1 ] ; then
  USERNAME=$1
else
  echo "Usage: sudo `basename $0` <user-name>"
  echo "<user-name> should be a user account"
  exit 1
fi

bashrc_fp="/home/$USERNAME/.bashrc"

# Check if user exists:
if [ ! -f "$bashrc_fp" ] ; then
  echo "User $USERNAME is not found."
  exit 1
fi

echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] Append conda initialization to $bashrc_fp for $USERNAME" >&2

cat << EOF >> $bashrc_fp
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/shared/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/shared/conda/etc/profile.d/conda.sh" ]; then
        . "/shared/conda/etc/profile.d/conda.sh"
    else
        export PATH="/shared/conda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
EOF
