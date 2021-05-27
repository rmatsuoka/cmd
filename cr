#!/bin/sh

export IFS=' 	
'
SYSPATH=$(command -p getconf PATH 2>/dev/null)
export PATH="${SYSPATH:-/bin:/usr/bin}${PATH:+:$PATH}"
progname=$(basename "$0")

usage(){
	cat <<EOF
usage: $progname [-E] [-c color] pattern [file...]
EOF
}
help(){
	usage
	cat <<EOF

colorize the strings that match a pattern

OPTIONS
	-c color
		Specify a color from COLOR LIST.

	-E	Treat a pattern as extended regex.

OPERANDS
	 pattern
		Specify a pattern to be used colorize for input. Without
		-E option, the pattern is treated as basic regex.
	 file	Specify a pathname of files. If no file operands are
	 	specified, the stdin shall be used.
 
COLOR LIST
	 FULLNAME   ABBREV
	 black      k
	 red        r
	 green      g
	 yellow     y
	 blue       b
	 magenta    m
	 cyan       c
	 white      w
	 default    d
EOF
}
error(){
	printf '%s: %s\n' "$progname" "$1" 1>&2
	usage 1>&2
	exit 1
}

Eflag=
color='red'
ctlseq=
regex=

black=$(printf '\033[030m')
red=$(printf '\033[031m')
green=$(printf '\033[032m')
yellow=$(printf '\033[033m')
blue=$(printf '\033[034m')
magenta=$(printf '\033[035m')
cyan=$(printf '\033[036m')
white=$(printf '\033[037m')
default=$(printf '\033[039m')

while getopts c:Eh opt ; do
	case "$opt" in
	c)	color="$OPTARG";;
	E)	Eflag='-E';;
	h)	help; exit 0;;
	?)	usage 1>&2; exit 1;;
	esac
done
shift $((OPTIND - 1))

case "$color" in
black|k)   ctlseq=$black;;
red|r)     ctlseq=$red;;
green|g)   ctlseq=$green;;
yellow|y)  ctlseq=$yellow;;
blue|b)    ctlseq=$blue;;
magenta|m) ctlseq=$magenta;;
cyan|c)    ctlseq=$cyan;;
white|w)   ctlseq=$white;;
default|d) ctlseq=$default;;
*)         error "illegal color -- $color";;
esac

regex=${1:-'.*'}
[ $# -ge 1 ] && shift

# escape '/' in regex for sed
regex="$(printf '%s\n' "$regex" | sed 's:/:\\/:g')"

sed $Eflag 's/'"$regex"'/'"$ctlseq"'&'"$default"'/g' -- ${1+"$@"} 
