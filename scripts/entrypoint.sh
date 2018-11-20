#!/bin/sh
set -e
echo "10.0.0.8  scitos" >> /etc/hosts
echo "10.0.0.239  SATELLITE-S50-B" >> /etc/hosts
echo "172.28.5.3 tsn_caffe" >> /etc/hosts
echo "history -s tmp/start.sh " >> /root/.bashrc
exec "$@"
