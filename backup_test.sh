#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Error: two arguments are required - the directory to be backed up, remote server IP and the destination directory for the backup archive."
    exit 1
fi

backup_dir=$1
dest=$2

if [ ! -d "$backup_dir" ]; then
    echo "Error: The directory $backup_dir does not exist."
    exit 1
fi

if [[ $dest == *":"* ]]; then
    rsync -avz -e ssh $bachup_dir $dest
    date=$(date +%Y-%m-%d)
    backup_name="backup-$date.tar.gz"
    tar -zcf "$dest/$backup_name" -C "$backup_dir" .

else
    if [ ! -d "$dest" ]; then
        echo "Error: The directory $dest does not exist."
        exit 1
    fi

    date=$(date +%Y-%m-%d)
    backup_name="backup-$date.tar.gz"
    tar -zcf "$dest/$backup_name" -C "$backup_dir" .
fi

echo "Backup complete: $dest"
