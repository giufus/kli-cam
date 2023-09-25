#!/bin/bash

# login username
USERNAM_SOU=$1

# target server
HOSTNAM=$2

# target user
USERNAM_TAR=$3

# target user tty
TTWAY=$4

install_rust() {
    if [ ! -f $HOME/.cargo/bin/cargo ] 
    then
        echo "Installing rust..."
        `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
        `source $HOME/.cargo/env`
    else 
        echo "Rust already installed"
    fi
}

install_aarty() {
    $HOME/.cargo/bin/cargo install aarty
}

asciify() {
    #$HOME/.cargo/bin/aarty --output-method file -o output.txt -s 15 -m colored -b black -c " .:-=+░▒▓▓" temp.jpg
    $HOME/.cargo/bin/aarty --output-method file -o output.txt -s 15  -c " .,-~!;:=*&%$@#" temp.jpg
}

## MAC
install_imagesnap() {
    if [ ! -f /opt/homebrew/bin/imagesnap ] 
    then
        echo "Installing imagesnap..."
        `brew install imagesnap`
    else 
        echo "Imagesnap already installed"
    fi
}

take_pic_mac() {
    /opt/homebrew/bin/imagesnap temp.jpg
}

## LINUX
install_fswebcam() {
    if [ ! -f /opt/homebrew/bin/imagesnap ] 
    then
        source /etc/os-release
        echo $PRETTY_NAME
        if [ $NAME = "Fedora" ]
        then
            sudo yum install fswebcam 
        elif [ $NAME = "Ubuntu" ] 
        then
            sudo apt install fswebcam
        else
            echo "Distribution not yet supported"
        fi
    else
        echo "Fswebcam already installed"
    fi
}


get_os() {
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)     machine=Linux;;
        Darwin*)    machine=Mac;;
        CYGWIN*)    machine=Cygwin;;
        MINGW*)     machine=MinGw;;
        MSYS_NT*)   machine=Git;;
        *)          machine="UNKNOWN:${unameOut}"
    esac
    echo "Os: ${machine}"
}
### -----------------------------------###
############# EXEC #######################
get_os
install_rust
install_aarty

if [ ${machine} = "Linux" ] 
then   
    install_fswebcam
elif [ ${machine} = "Mac" ] 
then    
    install_imagesnap
    take_pic_mac
    asciify 
    cat output.txt | ssh ${USERNAM_SOU}@${HOSTNAM} "write ${USERNAM_TAR} ${TTWAY}"
else 
    echo "Os not yet supported"
fi

