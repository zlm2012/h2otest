#! /bin/dumb-init /bin/bash

# stop when error occurs
set -e

# wait until source copying is finished
while [ ! -e /root/copy-finished ]; do
    sleep 5
done

# check if tarball exists
if [ ! -e /root/h2o.tar.gz ]; then
    echo "Please copy h2o tarball into this container"
    exit
fi

# extract the tarball
mkdir /h2o
tar zxf /root/h2o.tar.gz -C /h2o
chown -R user.user /h2o

cd /h2o
# build & check under normal user
sudo -u user /build.sh

# if everything goes right under normal user, we run the final tests as root
make check-as-root

# hooray!!!
GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo -e "${GREEN}All test passed! Congratulations!${NC}"
