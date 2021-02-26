#!/bin/sh

export IFS=' 	
'
SYS_PATH=$(command -p getconf PATH 2>/dev/null)
export PATH="${SYS_PATH:-/bin:/usr/bin}${PATH:+:}${PATH}"
prgname=$(basename "$0")

sflag=0
fname=
width=$(tput cols 2> /dev/null)
: ${width:=80}

while [ $# -gt 0 ]; do
	case "$1" in
	-)	sflag=1
		;;
	-[0-9]*)
		width=${1#-}
		;;
	-*)	:
		;;
	*)	break
		;;
	esac
	shift
done

width=${width%%[!0-9]*}

{
[ $# -eq 0 ] && cat -
for i; do
	if [ -f "$i" ]; then
		case "$i" in /*) :;; *) i="./$i" ;; esac
		printf '%s\n' "$i"
	elif [ -d "$i" ]; then
		echo /dev/null
	else
		printf '%s: can'\''t open %s (No such file or directory)\n' "$prgname" "$i" 1>&2
		echo /dev/null
	fi
done |
while read -r fname; do
	cat "$fname"
done
} |
awk '
function ceil(x){
	return int(x) + (x - int(x) > 0)
}
function printmc(l, n, x, col, row){
	# l is a line array
	# n is a number of lines
	# x is the max length of lines

	col = int(width / (x + 1))
	col = (0 == col) ? 1 : col
	row = ceil(n / col)

	for(i = 0; i < row; i++){
		# until the last element but one each col
		for(j = 0; j < (col - 1) && ((j + 1)*row + i) < n; j++){
			printf("%-*s ", x, l[j*row + i])
		}
		printf("%s\n", l[j*row + i])
	}
}
BEGIN{
	numline = 0
	maxlen = 0
}
sflag && $0 ~ /:$/{
	printmc(line, numline, maxlen)
	if(NR != 1){
		print ""
	}
	print $0
	maxlen = 0
	numline = 0
	next
}
{
	len=length($0)
	maxlen = (len > maxlen) ? len : maxlen
	line[numline] = $0
	numline++
}
END{
	printmc(line, numline, maxlen)
}' sflag=$sflag width=$width
