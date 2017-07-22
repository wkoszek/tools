O=$1
shift
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$O `/bin/ls -1rt $* | xargs`
#"/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py" -o $O $*
