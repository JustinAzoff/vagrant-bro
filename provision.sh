#!/bin/bash

VERSION=2.2


export DEBIAN_FRONTEND=noninteractive

function pre_setup {
    #apt-get update > /dev/null
    apt-get dist-upgrade -y
}

function install_prereqs {
    apt-get -y install build-essential
    apt-get -y install bison flex cmake swig
    apt-get -y install libssl-dev libgeoip-dev libmagic-dev libpcap-dev python-dev libcurl4-openssl-dev
}

function die {
    echo $*
    exit 1
}

function install_bro {
    if [ -e /usr/local/bro/bin/bro ] ; then
        echo "bro already installed"
        return
    fi
    if [ ! -e bro-${VERSION}.tar.gz ] ; then
        echo "downloading bro"
        wget -c http://www.bro.org/downloads/release/bro-${VERSION}.tar.gz --progress=dot:mega
    fi
    if [ ! -e bro-${VERSION} ] ; then
        echo "untarring bro"
        tar xzf bro-${VERSION}.tar.gz
    fi
    cd bro-${VERSION}
    ./configure || die "configure failed"
    make || die "build failed"
    sudo make install || die "install failed"

    
}

pre_setup
install_prereqs
install_bro

exit 0
