#!/bin/sh

export IFS=' 	
'
syspath=$(command -p getconf PATH 2>/dev/null)
export PATH="${syspath:-/bin:/usr/bin}${PATH:+:$PATH}"
progname=$(basename "$0")
synposis="$progname [-h]"

warn(){
	printf '%s: %s\n' "$progname" "$*" >&2
}

fatal(){
	[ -n "$1" ] && warn "$1"
	printf 'usage: %s\n' "$synposis" >&2
	exit ${2-"1"}
}

usage(){
	cat >&2 <<EOF
NAME
	$progname -- a template for shellscript

SYNOPSIS
	$synposis

OPTIONS
	-h	show this

EXAMPLE
	\$ $progname
EOF
	exit 1
}

while getopts h flag; do
	case "$flag" in
	h)	usage;;
	?)	fatal;;
	esac
done
shift $((OPTIND - 1))

cat "$0"
