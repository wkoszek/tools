#!/bin/sh

EX_USAGE=64
CTAGS=exctags
if [ `uname -s` = "Linux" ]; then
	CTAGS="ctags"
fi

if [ $# -eq 0 ]; then
	echo "tags_db dir";
	exit $EX_USAGE
fi

DIR=${1}

find $DIR -name "*.[chsly]" -type f > ${DIR}/_.f
cscope -b -k -f cscope.files -i ${DIR}/_.f
$CTAGS -L ${DIR}/_.f
rm ${DIR}/_.f
mv ${DIR}/cscope.files ${DIR}/cidx.db

