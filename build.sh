#! /bin/bash

set -e

# check if copied source directory exists
[ -d "/h2o" ] || exit 1

# remove files disturbing build
[ -d "/h2o/CMakeFiles" ] && rm -rf /h2o/CMakeFiles
[ -e "/h2o/CMakeCache.txt" ] && rm /h2o/CMakeCache.txt
[ -d "/h2o/mruby" ] && rm -rf /h2o/mruby

cd /h2o

# ensure that submodules are properly initialized
git submodule update --init --recursive

# try to compile
cmake -DWITH_MRUBY=ON .
make all

# seems we need to connect wikipedia first for passing 50reverse-proxy-https.t with some unknown reason
curl -O https://en.wikipedia.org/wiki/Main_Page

sleep 1

# run tests under normal user
make check
