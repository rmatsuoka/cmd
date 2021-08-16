#!/bin/sh

export IFS=' 	
'
syspath=$(command -p getconf PATH 2>/dev/null)
export PATH="${syspath:-/bin:/usr/bin}${PATH:+:$PATH}"
progname=$(basename "$0")
usage="$progname [-h] [-A] [-s SIGNAL_NAME] procname..."

displayHelp(){
	cat <<EOF
NAME
	$progname - kill process by name

SYNOPSIS
	$usage

OPTIONS
	-A
	-s SIGNAL_NAME
	-h

EXAMPLES
	$progname -s KILL xeyes firefox | sh

BUGS
	If you run this on a busybox environment, you must specify -A.
EOF
}

userlist="-U $(id -un)"
killcmd=$(command -pv kill)
sigName=TERM

while getopts As:h flag; do
	case "$flag" in
	A)	userlist="-A";;
	s)	sigName="$OPTARG";;
	h)	displayHelp;;
	?)	printf "usage: $usage\n" >&2; exit 1;;
	esac
done
shift $((OPTIND - 1))

for proc; do
	ps -o pid,user,args $userlist | sed 1d |
	awk -v proc="$proc" -v killcmd="$killcmd" -v sigName="$sigName" '
	function base(p) {
		sub(/.*\//, "", p)
		sub(/:$/, "", p)
		sub(/^-/, "", p)
		return p
	}
	base($3) == proc {
		printf("%s -s %s %d # %s %s\n", killcmd, sigName, $1, $2, $3)
	}'
done
