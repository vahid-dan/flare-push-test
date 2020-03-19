#!/bin/bash

# Takes 3 arguments and returns the first one that is not null
function set_value (){
	[[ ! -z $1 ]] && echo $1 || ([[ ! -z $2 ]] && echo $2 || echo $3)
}

dpkg -s yq 2> /dev/null > /dev/null || (sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64 && \
	sudo add-apt-repository ppa:rmescandon/yq && \
	sudo apt-get update && \
	sudo apt-get install -y yq)

CONTAINER_NAME="flare-push-test"

SHAREDDIRECTORY=$(yq r $CONFIGFILE shared-directory)

APPDIRECTORY_DEFAULT="/root/app"
APPDIRECTORY_GENERAL=$(yq r $CONFIGFILE app-directory)
APPDIRECTORY=$(set_value $APPDIRECTORY_GENERAL $APPDIRECTORY_DEFAULT)

SSHKEY_PUBLIC_DEFAULT=$([[ $EUID -eq 0 ]] && echo "/root/.ssh/id_rsa.pub" || echo "/home/$USER/.ssh/id_rsa.pub")
SSHKEY_PUBLIC_GENERAL=$(yq r $CONFIGFILE ssh-key.public)
SSHKEY_PUBLIC_CONTAINER=$(yq r $CONFIGFILE $CONTAINER_NAME.git.ssh-key.public)
SSHKEY_PUBLIC=$(set_value $SSHKEY_PUBLIC_CONTAINER $SSHKEY_PUBLIC_GENERAL $SSHKEY_PUBLIC_DEFAULT)

SSHKEY_PRIVATE_DEFAULT=$([[ $EUID -eq 0 ]] && echo "/root/.ssh/id_rsa" || echo "/home/$USER/.ssh/id_rsa")
SSHKEY_PRIVATE_GENERAL=$(yq r $CONFIGFILE ssh-key.private)
SSHKEY_PRIVATE_CONTAINER=$(yq r $CONFIGFILE $CONTAINER_NAME.git.ssh-key.private)
SSHKEY_PRIVATE=$(set_value $SSHKEY_PRIVATE_CONTAINER $SSHKEY_PRIVATE_GENERAL $SSHKEY_PRIVATE_DEFAULT)

cp -u $SSHKEY_PRIVATE $SSHKEY_PUBLIC $SHAREDDIRECTORY

DOCKER_RUN_COMMAND="docker run --rm -it -v $SHAREDDIRECTORY:$APPDIRECTORY $CONTAINER_NAME $APPDIRECTORY/script-container.sh"

# Run docker
$DOCKER_RUN_COMMAND