#!/bin/sh

export IFS=' 	
'
syspath=$(command -p getconf PATH 2>/dev/null)
export PATH="${syspath:-/bin:/usr/bin}${PATH:+:PATH}"
progname=$(basename "$0")

colon=0
width=$(tput cols 2> /dev/null)
test -n "$width" || width=80

while [ $# -gt 0 ]; do
	case "$1" in
	-)	colon=1;;
	-[0-9]*)
		width=${1#-};;
	-*)	:;;
	*)	break;;
	esac
	shift
done
width=${width%%[!0-9]*}

awk -v colon=$colon -v width=$width '
	function ceil(x){
		return int(x) + (x - int(x) > 0)
	}

	function printmc(l, n, x,         i, j, col, row){
		# l is a array of lines
		# n is a number of lines
		# x is the max length of lines

		col = int(width / (x + 1))
		col = (0 == col) ? 1 : col
		row = ceil(n / col)

		for(i = 0; i < row; i++){
			# print elements but the last one
			for(j = 0; j + 1 < col && ((j + 1)*row + i) < n; j++){
				printf("%-*s ", x, l[j*row + i])
			}
			# print the last element
			printf("%s\n", l[j*row + i])
		}
	}

	BEGIN{
		lineno = 0
		maxlen = 0
	}

	colon && $0 ~ /:$/{
		if(NR != 1){
			printmc(line, lineno, maxlen)
			print ""
		}
		print $0

		lineno = 0
		maxlen = 0
		next
	}

	{
		len=length($0)
		maxlen = (len > maxlen) ? len : maxlen
		line[lineno] = $0
		lineno++
	}

	END{
		printmc(line, lineno, maxlen)
	}' ${1+"$@"}
exit $?
