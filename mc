#!/bin/sh

export IFS=' 	
'
export PATH='/usr/bin:/bin'
prgname=$(basename "$0")

sflag=0
width=
width_default=80
TAB=4
fname=

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

for i; do
	if [ -f "$i" ]; then
		fname="$fname \"$i\""
	elif [ -d "$i" ]; then
		fname="$fname /dev/null"
	else
		printf '%s: can'\''t open %s (No such file or directory)\n' "$prgname" "$i" 1>&2
		fname="$fname /dev/null"
	fi
done
: ${fname:=-}

if [ -z "$width" ];then
	width=$(tput cols) || width=$width_default
else
	width=${width%%[!0-9]*}
fi

eval cat "$fname" |
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
			printf("%-*s ", x, line[j*row + i])
		}
		printf("%s\n", line[j*row + i])
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
