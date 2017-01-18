#!/bin/bash
# Copyright 2017 Wojciech Adam Koszek <wojciech@koszek.com>
#
# command from: http://www.uponmyshoulder.com/blog/2010/put-os-x-to-sleep-via-command-line/

sleep $1 && pmset sleepnow
