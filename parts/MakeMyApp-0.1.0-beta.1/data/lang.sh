#!/usr/bin/env bash

#--------------- Self -------------------------------------------------#
BASE_DIR="$( dirname "$( realpath "${BASH_SOURCE[0]}" )" )"
SCRIPT_NAME="$(basename "$0")"

#-------------- Source: location --------------------------------------# 
FUNC_OUTPUT="${BASE_DIR}/func/output.sh"

#-------------- Source: validation-------------------------------------# 
bash -n "$FUNC_OUTPUT" &> /dev/null || invalid_parts+=( "Invalid File: $FUNC_OUTPUT\n")
(( ${#invalid_parts} > 0 )) && printf "%b" "${invalid_parts[*]}" && exit 1

#-------------- Source: includation -----------------------------------#
source "$FUNC_OUTPUT"

#--------------- Define Defs ------------------------------------------#
DEF_LOG="${BASE_DIR}/makemyapp.log"

#--------------- Set Defs if unset ------------------------------------#
ERR_LOG="${ERR_LOG:-$DEF_LOG}"


############### FUNCTIONS ##############################################

GetSysLang(){
	local lang
	lang="${LANG%%_*}"
	lang="${lang,,}"
	
	DebugLog "System language: $lang" "INFO"  "$LINENO"
	printf "%s" "$lang"
	
}

SetLanguage() {
	local lang="$(GetSysLang)"
	if [[ "$(locale charmap 2>/dev/null)" == "UTF-8" ]]; then
		case "$lang" in
			de*) lang="de" ;;
			en*) lang="en" ;;
			fr*) lang="fr" ;;
			es*) lang="es" ;;
			it*) lang="it" ;;
			pt*) lang="pt" ;;
			nl*) lang="nl" ;;
			no*) lang="no" ;;
			sv*) lang="sv" ;;
			pl*) lang="pl" ;;
			tr*) lang="tr" ;;
			ru*) lang="ru" ;;
			zh*) lang="zh" ;;
			ja*) lang="ja" ;;
			ko*) lang="ko" ;;
			hi*) lang="hi" ;;
			mr*) lang="mr" ;;
			ur*) lang="ur" ;;
			id*) lang="id" ;;
			ar*) lang="ar" ;;
			*)   lang="en" ;;
		esac
	else
		lang="en"
	fi

	DebugLog "Set language: $lang" "INFO"  "$LINENO"
	printf "%s" "$lang"
	
}


############### MAIN ###################################################

DebugLog " " "START"
SetLanguage
DebugLog " " "END"

exit 0
