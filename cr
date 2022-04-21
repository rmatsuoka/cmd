#!/bin/sh

export IFS=' 	
'
syspath=$(command -p getconf PATH 2>/dev/null)
export PATH="${syspath:-/bin:/usr/bin}${PATH:+:$PATH}"
progname="$(basename "$0")"

usage(){
	cat <<EOF >&2
usage: $progname [-E] [-c color] pattern [file...]
  -c color
      Specify a color as FULLNAME or ABBREV in COLOR LIST.

  -E  Treat a pattern as extended regex.

  pattern
	sed-style regex.
 
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
	exit 1
}

fatal(){
	printf '%s: %s\n' "$progname" "$1" 1>&2
	exit 1
}

Eflag=
ctlseq=
regex=
color='red'

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
	h|?)	usage;;
	esac
done
shift $((OPTIND-1))

if [ $# -lt 1 ]
then
	fatal 'no pattern specified'
fi
regex="$1"
shift


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
*)         fatal "unknown color -- $color";;
esac

# escape '/' in regex for sed
regex="$(printf '%s\n' "$regex" | sed 's:/:\\/:g')"

sed $Eflag -- s/"$regex"/"$ctlseq"'&'"$default"/g ${1+"$@"}
