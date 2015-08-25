#!/bin/sh

if [ "x$1" = "x" ]; then
	echo "./github_qa <root_dir> [github_user]"
	echo "Help:"
	echo "root_dir\tis where you checkout all your repos"
	echo "github_user\tis your GitHub's user name"
	exit 1
fi
ROOT_DIR=$1

USER=`whoami`
if [ "x$2" != "x" ]; then
	USER=$2
fi

CI_CONFIGS=".travis.yml circle.yml wercker.yml appveyor.yml"

function github_qa_check_ci_enabled() {
	RET=0
	for CI_CONFIG in ${CI_CONFIGS}; do
		if [ -e $1/${CI_CONFIG} ]; then
			RET=1
		fi
	done
	if [ $RET -eq 0 ]; then
		echo "$1 doesn't have a continuous integration system enabled!"
	fi
	return $RET
}

function github_qa_check() {
	(
		echo =================== $1
		cd $1
		#make clean 2>&1 > /dev/null
		git status --porcelain
		github_qa_check_ci_enabled $1
	)
}

function github_qa_check_all() {
	for REPO in `gh re --list | grep ^wkoszek`; do
		REPO_MINUS_USER=`basename $REPO`
		REPO_DIR=${ROOT_DIR}/${REPO_MINUS_USER}
		if [ ! -d ${REPO_DIR} ]; then
			echo "${REPO_DIR} doesn't exist"
		else
			github_qa_check ${REPO_DIR}
		fi
	done
}

github_qa_check_all

