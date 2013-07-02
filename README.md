asteroid-oracle-builder
=======================

Asteroid Oracle Builder



Build Pre-requisites:
---------------------

On all platforms, ensure Node is installed and that the node and npm
binaries are in the PATH.


On Ubuntu systems, install unzip, make and g++

    sudo apt-get install unzip make g++


On MacOSX, ensure Xcode is installed and you have the compilers to 
build C/C++ code. 


On RHEL based systems, install the following RPMs.

    # Install or update audit.
    # sudo yum install audit  OR
    sudo yum update audit
    sudo yum install @development-tools
    sudo yum install fedora-packager



To Build:
---------
Currently supported build environments are: Ubuntu (32+64 bit),
RHEL(32+64 bit) and Mac OSX (64 bit only).

To build the asteriod-oracle bits, simply run:

    make   #   Internally all this does is call ./build/bin.sh

The built package can be found in the build/$platform directory and should
be named something of the form:

    asteroid-oracle_${platform}_${version}_${arch}.tar.gz

    Example: asteroid-oracle_MacOSX_0.1-0_x86_64.tar.gz


The packages need to be uploaded to a public site (ala www.strongloop.com)
in order for the associated installer to be able to download and install
it.

