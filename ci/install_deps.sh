#!/usr/bin/env bash

# Copyright (C) 2020-2021 IBM Corp.
# This program is Licensed under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#   http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License. See accompanying LICENSE file.

set -xe

if [ "$#" -ne 4 ]; then
  echo "Wrong parameter number. Usage ./${0} <PACKAGE_BUILD> <RUNNER_OS> <C_COMPILER> <CXX_COMPILER>"
  exit 1
fi

PACKAGE_BUILD="${1}"
RUNNER_OS="${2}"
C_COMPILER="${3}"
CXX_COMPILER="${4}"

# TODO: install only if needed
git clone https://github.com/intel/hexl.git -b v1.2.1
cd hexl
cmake -B build \
  -DCMAKE_INSTALL_PREFIX=./ \
  -DHEXL_SHARED_LIB=OFF \
  -DCMAKE_C_COMPILER="${C_COMPILER}" \
  -DCMAKE_CXX_COMPILER="${CXX_COMPILER}"
cmake --build build -j4 --target install
cd ../

cd $HOME

if [ "${RUNNER_OS}" == "ubuntu-20.04" ]; then
    sudo apt-get -yq --no-install-suggests --no-install-recommends install libgmp-dev libntl-dev bats
fi

if [ "${RUNNER_OS}" == "macos-latest" ]; then
  brew install ntl
fi



# if [ "${PACKAGE_BUILD}" == "OFF" ]; then
#   if [ "${RUNNER_OS}" == "Linux" ]; then
#     sudo apt-get -yq --no-install-suggests --no-install-recommends install libgmp-dev libntl-dev bats
#   fi
# fi
  # if [ "${TRAVIS_OS_NAME}" == "linux" ]; then
    # if [ "${TRAVIS_DIST}" == "bionic" ]; then
    #   sudo apt-get -yq --no-install-suggests --no-install-recommends $(travis_apt_get_options) install m4 libgmp-dev
    #   curl -O "https://libntl.org/ntl-11.4.3.tar.gz"
    #   tar --no-same-owner -xf ntl-11.4.3.tar.gz
    #   cd "$HOME/ntl-11.4.3/src"
    #   ./configure SHARED=on NTL_GMP_LIP=on NTL_THREADS=on NTL_THREAD_BOOST=on
    #   make -j4
    #   sudo make install
    # else
#       sudo apt-get -yq --no-install-suggests --no-install-recommends install libgmp-dev libntl-dev
#     # fi
#   elif [ "${TRAVIS_OS_NAME}" == "osx" ]; then
#     # GMP will be installed as a dependency to NTL (if it is not already present)
#     brew install ntl
#   fi
# else
#   if [ "${TRAVIS_OS_NAME}" == "linux" ]; then
#     sudo apt-get -yq --no-install-suggests --no-install-recommends $(travis_apt_get_options) install patchelf m4
#   elif [ "${TRAVIS_OS_NAME}" == "osx" ]; then
#     brew install m4
#   fi
# fi

# cd "$HOME"
