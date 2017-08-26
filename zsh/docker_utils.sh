rm_dangling_images() {
    docker rmi $(docker images -q -f dangling=true)
}

rm_containers() {
    docker container rm $(docker container ls -aq)
}

env_docker() {
    name=${1:-aws-gpu}
    eval $(docker-machine env $name)
    echo "$(docker-machine active) now active."
}

unenv_docker() {
    eval $(docker-machine env -u)
}

create_aws() {
    name=${1:-aws}
    machine=${2:-m4.xlarge}
    region=${3:-eu-central-1}

    if [ ! $region = "eu-central-1" ] && [ ! $region = "eu-west-1" ]; then
	echo "Region $region is not supported"
	return 1
    fi
    
    if [ ${machine:0:2} = "p2" ]; then
	echo "Creating a GPU machine"
	if [ $region = "eu-west-1" ]; then
	    # nvidia-docker ubuntu 14.04 eu-west-1
	    ami=ami-827296fb
	else
	    # nivida-docker ubuntu 14.04 eu-central-1
	    ami=ami-860caee9
	fi
    else
	echo "Creating a non-GPU machine"
	if [ $region = "eu-west-1" ]; then
	    echo "ubuntu 14.04 eu-west-1 not supported."
	    echo "lookup ami on aws"
	    return 1
	else
	    # ubuntu 14.04 eu-central-1
	    ami=ami-344fe85b
	fi
    fi

    echo "Name: $name, Machine: $machine, Region: $region, AMI: $ami"
    
    docker-machine rm -f $name
    aws ec2 delete-key-pair --region $region --key-name $name
    docker-machine create \
		   --driver amazonec2 \
		   --amazonec2-instance-type $machine \
		   --amazonec2-region $region \
		   --amazonec2-ami $ami \
		   $name
}

config_aws_gpu() {
    ssh-add "$HOME/.docker/machine/machines/$DOCKER_MACHINE_NAME/id_rsa" > /dev/null 2>&1
    ssh -o "StrictHostKeyChecking no" -f -N -L 3476:localhost:3476 ubuntu@`docker-machine ip $DOCKER_MACHINE_NAME` > /dev/null 2>&1
    curl -s localhost:3476/docker/cli
}

start_aws() {
    docker-machine start $1
    docker-machine regenerate-certs $1 -f
    env_docker $1
}
