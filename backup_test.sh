#!/bin/bash

if [ "$#" -ne 2 ]; then
   echo "Error: two arguments are required - the directory to be backed up, remote server IP and the destination directory for the backup archive."
   exit 1
fi

source_dir=$1
target_dir=$2

if [[ $target_dir == *":"* ]]; then
  # Use rsync over ssh for remote targets
  server_and_dir=$target_dir
  server=$(echo $server_and_dir | awk -F':' '{print $1}')
  remote_dir=$(echo $server_and_dir | awk -F':' '{print $2}')
 
  timestamp=$(date +%Y-%m-%d_%H-%M-%S)
  backup_dir="$remote_dir/$timestamp"
  ssh $server "mkdir $backup_dir"

  rsync -avz -e "ssh -T" --link-dest=$server:$remote_dir/latest $source_dir $server:$backup_dir

# Update the symlink for the latest backup
  ssh $server "ln -snf $backup_dir $remote_dir/latest"

else
  # Use local rsync for local targets 

 timestamp=$(date +%Y-%m-%d_%H-%M-%S)
 backup_dir="$target_dir/$timestamp"

 mkdir $backup_dir

 rsync -avz --link-dest=$target_dir/latest $source_dir $backup_dir

# Update the symlink for the latest backup
 ln -snf $backup_dir $target_dir/latest
fi
