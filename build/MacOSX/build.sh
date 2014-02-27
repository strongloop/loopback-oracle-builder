#!/bin/bash

thisdir=$(dirname "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(cd -P -- "$thisdir" && pwd -P)
source "$SCRIPT_DIR/../../lib/utils"

DEBUG_BUILD_SCRIPT=""  #  Set to any string to debug.
TEMP_BUILD_DIR="$SCRIPT_DIR/temp_build_dir"


#
#  Initializes the build (currently just cleans up + creates build directories).
#
#  Example:
#    initialize_build
#
function initialize_build() {
  rm -rf "$TEMP_BUILD_DIR"
  mkdir -p "$TEMP_BUILD_DIR"

}  #  End of function  initialize_build.


#
#  Extracts the Oracle InstantClient basiclite and sdk packages for the
#  specific platform and architecture we are building on/for.
#
#  Example:
#    extract_ic_packages
#
function extract_ic_packages() {
  package_prefix="instantclient"
  packages=( basiclite sdk )

  build_os="macos"
  zipdir=$ORA_PACKAGES_DIR/$BUILD_PLATFORM/$BUILD_ARCH

  pushd "$TEMP_BUILD_DIR" > /dev/null

  for pkg in $(echo ${packages[@]}); do
    print_message ""
    print_message "- Extracting package $pkg ..."
    zf=$(ls $zipdir/${package_prefix}*-$pkg-${build_os}.x64-*.zip | head -1)
    if [ -n "$DEBUG_BUILD_SCRIPT" ]; then
      print_message "    zip file = $zf"
      print_message "    dest dir = $pkg"
    fi

    mkdir -p "$pkg"

    pushd "$pkg" > /dev/null
    unzip "$zf"
    popd > /dev/null

    print_message "- Done extracting package $pkg"
  done

  popd > /dev/null

}  #  End of function  extract_ic_packages.


#
#  Creates symbolic links to the Oracle shared libraries.
#
#  Example:
#    create_ic_dso_symlinks
#
function create_ic_dso_symlinks() {
  pkg="basiclite"
  libs_to_link=( libclntsh.dylib libocci.dylib )

  
  pushd "$TEMP_BUILD_DIR/$pkg" > /dev/null

  latest_ver=$(find . -maxdepth 1 -type d | egrep -ve '^\.$' | sort | tail -1)
  cd "${latest_ver}" 

  for dso in $(echo "${libs_to_link[@]}"); do
    zdso=$(ls ${dso}.*.* | head -n 1)
    ln -sf $zdso $dso
  done

  popd > /dev/null

}  #  End of function  create_ic_dso_symlinks.


#
#  Returns the location of the Oracle InstantClient SDK include directory.
#
#  Example:
#    get_oracle_sdk_include_dir
#
function get_oracle_sdk_include_dir() {
  pushd "$TEMP_BUILD_DIR/sdk" > /dev/null
  latest_ver=$(find . -maxdepth 1 -type d | egrep -ve '^\.$' | sort | tail -1)
  cd "$TEMP_BUILD_DIR/sdk/${latest_ver}"/sdk/include
  sdk_include_dir=`pwd`
  popd > /dev/null

  echo "$sdk_include_dir"

}  #  End of function  get_oracle_sdk_include_dir.


#
#  Returns the location of the Oracle InstantClient library directory.
#
#  Example:
#    get_oracle_lib_dir
#
function get_oracle_lib_dir() {
  pushd "$TEMP_BUILD_DIR/basiclite" > /dev/null
  latest_ver=$(find . -maxdepth 1 -type d | egrep -ve '^\.$' | sort | tail -1)
  cd "$TEMP_BUILD_DIR/basiclite/${latest_ver}"/
  ora_client_dir=`pwd`
  popd > /dev/null

  echo "$ora_client_dir"

}  #  End of function  get_oracle_lib_dir.


#
#  Installs and builds the node oracle npm module.
#
#  Example:
#    install_node_oracle_module
#
function install_node_oracle_module() {
  export OCI_INCLUDE_DIR=$(get_oracle_sdk_include_dir)
  export OCI_LIB_DIR=$(get_oracle_lib_dir)

  print_message ""
  print_message "- Installing/Building strong-oracle module ..."
  print_message "    OCI_INCLUDE_DIR = $OCI_INCLUDE_DIR"
  print_message "        OCI_LIB_DIR = $OCI_LIB_DIR"
  print_message ""

  rm -rf "$TEMP_BUILD_DIR/install"
  mkdir -p "$TEMP_BUILD_DIR/install"

  pushd "$TEMP_BUILD_DIR/install" > /dev/null
  pwd
  # Fool npm so that it will install the module locally
  echo '{}' > package.json
  if npm install $NODE_ORACLE_MODULE; then
    print_message ""
    print_message "- Local install/build completed."
  else
    print_message ""
    print_message "ERROR: ***  Local install/build of node oracle FAILED! *** "
    echo  "ERROR: Exiting due to build failure."
    exit 255
  fi

  popd > /dev/null

}  #  End of function  install_node_oracle_module.


#
#  Initialize package environment.
#
#  Example:
#    initialize_package_env
#
function initialize_package_env() {
  pkg_dir="$TEMP_BUILD_DIR/packages"

  print_message "- Cleaning old package directory ..."
  rm -rf "$pkg_dir"
  mkdir -p "$pkg_dir/$BUILD_ARCH/"

  print_message "- Initializing package directory ..."
  cp -r "$SCRIPT_DIR/rpm" "$pkg_dir/$BUILD_ARCH/"

  arch=$BUILD_ARCH
  [ "$arch" == "x86_64" ] && arch="amd64"

}  #  End of function  initialize_package_env.


#
#  Replace the strong-oracle package's gyp binding.
#
#  Example:
#    replace_package_gyp_binding
#
function replace_package_gyp_binding() {
   # cp -f "$SCRIPT_DIR/../../misc/binding.gyp" "$TEMP_BUILD_DIR/install/node_modules/strong-oracle/"
   # Remove package.json to avoid rebuild
   rm -f "$TEMP_BUILD_DIR/install/node_modules/strong-oracle/package.json"

}  #  End of function  replace_package_gyp_binding.


#  Package up the node module and dependencies.
#
#  Example:
#    package_module_and_dependencies
#
function package_module_and_dependencies() {
  #  TODO: Just putting it all into 1 package for now. It makes more sense to
  #  split it into 2 separate packages (one for the oracle libs + one for the
  #  node module).

  pkg_dir="$TEMP_BUILD_DIR/packages"

  initialize_package_env

  print_message "- Packaging $BUILD_PACKAGE - $BUILD_ARCH version ..."

  pushd  "$pkg_dir/$BUILD_ARCH" > /dev/null
  # rpmbuild -ba $spec
  popd > /dev/null

  print_message "- Done packaging $BUILD_PACKAGE - $BUILD_ARCH version"
  print_message "- PACKAGES directory = $pkg_dir"

}  #  End of function  package_module_and_dependencies.


#
#  Build a downloadable tarball
#
#  Example:
#    build_downloadable_tarball
#
function build_downloadable_tarball() {
  tarball="$SCRIPT_DIR/${BUILD_PACKAGE}-${BUILD_PLATFORM}-${BUILD_ARCH}-${BUILD_VERSION}.tar"
  package="${tarball}.gz"

  ora_lib_dir=$(get_oracle_lib_dir)

  print_message "- Cleaning old package directory ..."
  rm -rf  "$TEMP_BUILD_DIR/tarball"
  mkdir -p "$TEMP_BUILD_DIR/tarball/instantclient"

  pushd "$TEMP_BUILD_DIR/tarball" > /dev/null
  cp -r "$TEMP_BUILD_DIR/install/node_modules"/*  ./
  # use -a to presever symbolic links
  cp -a "$ora_lib_dir"/*  instantclient/ 
  chmod -R ug+w instantclient

  print_message "- Creating downloadable tarball ..."
  tar -cf "$tarball" strong-oracle/ instantclient/

  print_message "- Gzipping tarball ..."
  rm -f "$package"
  gzip "$tarball"
  popd > /dev/null

  print_message "- Done creating a downloable tarball."
  print_message "- Gzipped tarball = $package"

}  #  End of function  build_downloadable_tarball.


#
#  main():
#
detect_platform

initialize_build

extract_ic_packages  &&  create_ic_dso_symlinks

install_node_oracle_module

replace_package_gyp_binding

# package_module_and_dependencies

build_downloadable_tarball

