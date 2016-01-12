#!/bin/sh

echo "# About to remove Git branch $1. CTRL-C to terminate"
read

git push origin --delete $1
git branch -D $1