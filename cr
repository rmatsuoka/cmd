#!/bin/sh

export IFS=' 	
'
export PATH='/usr/bin:/bin'
prgname=$(basename $0)

Eflag=
color='red'
ctlseq=

black=$(printf '\033[030m')
red=$(printf '\033[031m')
green=$(printf '\033[032m')
yellow=$(printf '\033[033m')
blue=$(printf '\033[034m')
magenta=$(printf '\033[035m')
cyan=$(printf '\033[036m')
white=$(printf '\033[037m')
default=$(printf '\033[039m')

error(){
	printf '%s: %s\n' "$prgname" "$@" 2>&1
	exit 1
}
help_msg(){
	cat <<EOF
Usage: $prgname [ -c <color> ] [ -E ] <regex> [ <file> ]

ColoRing text using Regex on a VT102 emulator

  <regex> Basic regex.
  <file>  A text file. if <file> is '-' or null, then read from stdin.

* Options
  -c <color> Specify color to convert regex-matching text (see color list)
  -E         Interpret <regex> as extended regex (You can specify this option if your sed has this option. This option is not POSIX compliant.)
 
* Color list
  black
  red
  green
  yellow
  blue
  magenta
  cyan
  white
  default
EOF
}

while [ $# -gt 0 ]; do
	case "$1" in
	-c)	color="$2"
		shift
		;;
	-E)	Eflag="$1"
		;;
	-h|--help)
		help_msg
		exit 0
		;;
	-*)	error "illegal option -- $1"
		;;
	--)	shift
		break
		;;
	*)	break
		;;
	esac
	shift
done

regrex="$1"
fname="${2:--}"

case "$color" in
black)	ctlseq=$black;;
red)	ctlseq=$red;;
green)	ctlseq=$green;;
yellow)	ctlseq=$yellow;;
blue)	ctlseq=$blue;;
magenta)	ctlseq=$magenta;;
cyan)	ctlseq=$cyan;;
white)	ctlseq=$white;;
default)	ctlseq=$default;;
*) error "illegal color -- $color";;
esac

regrex="$(printf '%s\n' "$regrex" | sed 's:/:\\/:g')"

case "$fname" in '-'|/*|./*|../*):;; *)fname="./$fname";;esac
if  [ "X$fname" != "X-" ] &&  ! [ -f "$fname" ];then
	error "$fname: No such file or directory"
fi

printf "$default"
cat "$fname" | sed $Eflag 's/'"$regrex"'/'"$ctlseq"'&'"$default"'/g'
