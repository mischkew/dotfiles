#! /bin/bash

create_key() {
    # 1 - key name
    # 2 - (optional) export path
    key_name=$1
    export_path=${2:-~/.ssh/}

    if [ -z $key_name ]; then
	echo "Aborting. No key name given."
	return 1
    fi
    
    if [ ! -d $export_path ]; then
	echo "Aborting. Directory does not exist: $export_path"
	return 1
    fi

    if [ -e $export_path/$key_name ]; then
	echo "Aborting. File already exists: $export_path/$key_name"
	return 1
    fi

    echo "Generating new key \"$key_name\" at $export_path"
    ssh-keygen -t rsa -b 4096 -C "$key_name" -f $export_path/$key_name
}

create_key $1 $2
