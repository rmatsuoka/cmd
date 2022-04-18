#!/bin/sh

export IFS=' 	
'
syspath=$(command -p getconf PATH 2>/dev/null)
export PATH="${syspath:-/bin:/usr/bin}${PATH:+:$PATH}"
progname=$(basename "$0")

warn(){
	printf '%s: %s\n' "$progname" "$*" >&2
}

fatal(){
	warn "$1"
	exit ${2-"1"}
}

usage(){
	printf 'usage: %s\n' "$progname" >&2
	exit 1
}

while getopts h flag; do
	case "$flag" in
	h|?)	usage;;
	esac
done
shift $((OPTIND - 1))

cat "$0"
