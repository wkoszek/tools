#!/bin/sh

vagrant global-status | awk '$3 ~ "virtualbox" { print "vagrant halt ", $1 }' | sh
