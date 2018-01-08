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

    mkdir -p $export_path

    if [ -e $export_path/$key_name ]; then
	echo "Aborting. File already exists: $export_path/$key_name"
	return 1
    fi

    echo "Generating new key \"$key_name\" at $export_path"
    ssh-keygen -t rsa -b 4096 -C "$key_name" -f $export_path/$key_name
}

add_key() {
    # 1 - key name
    # 2 - (optional) key path
    key_name=$1
    key_path=${2:-~/.ssh/}

    if [ -z $key_name ]; then
	      echo "Aborting. No key name given."
	      return 1
    fi

    if [ ! -e $key_name ]; then
      key_name=$keypath/$key_name
    fi

    if [ ! -e $key_name ]; then
	      echo "Aborting. File does not exist: $key_name"
	      return 1
    fi

    echo "Adding key \"$key_name\""
    ssh-add $key_name
}
