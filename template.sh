#!/bin/sh

export IFS=' 	
'
syspath=$(command -p getconf PATH 2>/dev/null)
export PATH="${syspath:-/bin:/usr/bin}${PATH:+:$PATH}"
progname=$(basename "$0")
usage="$progname [-h]"

help(){
	cat <<EOF 
NAME
	$progname -- a template for shellscript

SYNOPSIS
	$usage

OPTIONS
	-h	show this

EXAMPLE
	\$ $progname
EOF
}

while getopts h flag; do
	case "$flag" in
	h)	help >&2 ; exit 1;;
	?)	printf 'usage: %s\n' "$usage" >&2; exit 1;;
	esac
done
shift $((OPTIND - 1))

cat "$0"
