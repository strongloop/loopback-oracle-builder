loopback-oracle-builder
=======================

Loopback Oracle Builder builds [strong-oracle](https://github.com/strongloop/strong-oracle) module on various target
platforms, package the [Oracle instance client](http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html)
to create an installable archive to facilitate the installation of strong-oracle as a dependency.



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

On Windows systems, install cygwin and Visual Studio.

To Build:
---------
Currently supported build environments are: Linux (RHEL, CentOS, Debian, Ubuntu, Fedora) (32 & 64 bit),
Mac OSX (64 bit only), and Windows with cygwin (32 & 64 bit).

To build the loopback-oracle bits, simply run:

    make   #   Internally all this does is call ./build/bin.sh
    or
    ./build/bin.sh

The built package can be found in the build/$platform directory and should
be named something of the form:

    loopback-oracle-${platform}-${arch}-${version}.tar.gz

    Example: loopback-oracle-MacOSX-x64-0.0-1.tar.gz


The packages need to be uploaded to a public site (ala www.strongloop.com)
in order for the associated installer to be able to download and install
it.

