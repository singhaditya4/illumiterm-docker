#!/bin/bash
# get argv[1] and argv[2]
# argv[1] is the action name (build, run, clean) etc
# argv[2] is the package name
echo "----------------------------------------------------------------------"
echo "accetto/ubuntu-vnc-xfceOS/docker-pkgbuilder : docker container for building packages"
echo "----------------------------------------------------------------------"
if [ ! -d "build" ]; then
    mkdir build
fi
if [ "$1" == "help" ]; then
    echo "Usage: ./accetto/ubuntu-vnc-xfce.sh [action] [package name]"
    echo "Example: ./accetto/ubuntu-vnc-xfce.sh build neofetch"
    echo "----------------------------------------------------------------------"
    echo "Available actions:"
    echo "build : build a package"
    echo "run : run container"
    echo "download : download PKGBUILD files for all packages"
    exit 0
fi
if [ "$1" == "run" ]; then
    echo "Running container"
    sudo docker build -t accetto/ubuntu-vnc-xfce .
    docker run -it -p 25901:5901 -p 26901:6901 --rm accetto/ubuntu-vnc-xfce bash -c "bash"
    exit 0
fi
if [ "$1" == "build" ]; then
    echo "Building $2"
    sudo docker build -t accetto/ubuntu-vnc-xfce .
    docker run -it --rm accetto/ubuntu-vnc-xfce bash -c 'echo Hello' #'cd /tmp/packages && sudo -u user bash ./compile.sh $2 && bash'
    exit 0
fi
#autobuild
if [ "$1" == "autobuild" ]; then
    echo "Building all packages"
    sudo docker build -t accetto/ubuntu-vnc-xfce . --build-arg autobuild=true
    chmod +xrw build && chmod +xrw packages/*
    docker run -v $PWD/build:/tmp/build -it --rm accetto/ubuntu-vnc-xfce bash -c 'echo Hello' #'sudo chmod 777 /tmp/packages/neofetch && sudo chmod 777 /tmp/build && cd /tmp/packages && sudo -u user bash ./compile.sh' 
    #docker rm -f accetto/ubuntu-vnc-xfce
    exit 0
fi
if [ "$1" == "download"  ]; then
    echo "Downloading PKGBUILD files for all packages"
    # download PKGBUILD for neofetch from github latest release (accetto/ubuntu-vnc-xfceos/neofetch)
    chmod +xrw build && chmod +xrw packages/*
    bash ./download.sh
    exit 0
fi