#!/usr/bin/env bash

IsTypeJavaScript(){
	local file="$1"
	local mime

	[[ "$file" == *.js ]] || return 1 
	
	mime="$(file -b --mime-type -- "$file")"
	case "$mime" in
		application/javascript|text/plain|text/javascript|application/x-javascript|text/x-javascript)
			return 0
		;;
	esac

	return 1
}


IsTypeCss(){
	local file="$1"
	local mime
	
	mime="$(file -b --mime-type -- "$file")"

	case "$mime" in
		text/plain|text/css)
			return 0
		;;
	esac

	return 1
}


IsTypeXpi(){
	local file="$1"
	local mime

	[[ "$file" == *.xpi ]] || return 1 
	mime="$(file -b --mime-type -- "$file")"

	case "$mime" in
		application/zip)
			return 0
		;;
	esac
	echo "$mime"

	return 1
}


