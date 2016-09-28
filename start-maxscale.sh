#!/bin/bash
MasterNode_IP="`/usr/bin/curl -s http://rancher-metadata/latest/self/stack/services/MasterNode/containers/0/ips/0`"
SlaveNode1_IP="`curl -s http://rancher-metadata/latest/self/stack/services/SlaveNode1/containers/0/ips/0`"
SlaveNode2_IP="`curl -s http://rancher-metadata/latest/self/stack/services/SlaveNode2/containers/0/ips/0`"

/usr/bin/sed -i "s/10.42.254.99/${MasterNode_IP}/" /etc/maxscale.d/maxscale.cnf
/usr/bin/sed -i "s/10.42.254.10/${SlaveNode1_IP}/" /etc/maxscale.d/maxscale.cnf
/usr/bin/sed -i "s/10.42.254.20/${SlaveNode2_IP}/" /etc/maxscale.d/maxscale.cnf

/bin/sed -i "s/repluser/${REPLICATION_USER}/" /etc/maxscale.d/maxscale.cnf
/bin/sed -i "s/88888888/${REPLICATION_PASSWORD}/" /etc/maxscale.d/maxscale.cnf

/usr/bin/maxscale -d
