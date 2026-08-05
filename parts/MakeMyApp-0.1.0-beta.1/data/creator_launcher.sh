#!/usr/bin/env bash
PAR_lang="$1"
PAR_browser="$2"
PAR_launcher_profilename="$3"
PAR_launcher_name="$4"
PAR_launcher_icon="$5"
PAR_launcher_url="$6"

#--------------- Self -------------------------------------------------#

BASE_DIR="$(dirname -- "$(realpath "${BASH_SOURCE[0]}")")"
SCRIPT_NAME="$(basename "$0")"

#-------------- Source: location --------------------------------------# 
#Source Config 
CONF_MAIN="${BASE_DIR}/conf/conf_create_launcher.sh"


#Source: functions
FUNC_CONFIGPARSER="${BASE_DIR}/func/configparser.sh" 
FUNC_OUTPUT="${BASE_DIR}/func/output.sh"
FUNC_ISIT="${BASE_DIR}/func/isit.sh" 

#Source: text
TEXT_DEFAULT="${BASE_DIR}/lang/en/txt_create_launcher.conf"
TEXT_SOURCE="${BASE_DIR}/lang/$PAR_lang/txt_create_launcher.conf"

#-------------- Source: validation-------------------------------------# 

#Source: validation functions
bash -n "$FUNC_CONFIGPARSER" &> /dev/null || invalid_parts+=( "Invalid File: $FUNC_CONFIGPARSER line: ${LINENO[@]}")
bash -n "$FUNC_OUTPUT" &> /dev/null || invalid_parts+=( "Invalid File: $FUNC_OUTPUT line: ${LINENO[@]}")
bash -n "$FUNC_ISIT" &> /dev/null || invalid_parts+=( "Invalid File: $FUNC_ISIT line: ${LINENO[@]}")

#Source validation: Text
[[ -r "$TEXT_DEFAULT" ]] || invalid_parts+=( "Invalid File: $TEXT_DEFAULT line: ${LINENO[@]}")

(( ${#invalid_parts} > 0 )) && printf "%b" "${invalid_parts[*]}" && exit 1

DEF_LOG="${BASE_DIR}/makemyapp.log"
ERR_LOG="${ERR_LOG:-$DEF_LOG}"

#-------------- Source: includation -----------------------------------#

source "$FUNC_CONFIGPARSER" 
source "$CONF_MAIN"
source "$FUNC_OUTPUT"
source "$FUNC_ISIT" 

#--------------- Define Defs ------------------------------------------#

DEF_LOG="${BASE_DIR}/makemyapp.log"
DEF_DST_LAUNCHER="$( xdg-user-dir DESKTOP )"

#--------------- Set Defs if unset ------------------------------------#

ERR_LOG="${ERR_LOG:-$DEF_LOG}"
DST_LAUNCHER="${DST_LAUNCHER:-"$DEF_DST_LAUNCHER"}"

########################################################################
convert_filename(){
	local input="$1"
	local name
	DebugLog "\$1 input: $input" "INFO" "$LINENO"
	
	name="${input,,}"
	name="${name//ä/ae}"
	name="${name//ö/oe}"
	name="${name//ü/ue}"
	name="${name//ß/ss}"

	# replace unwanted
	name="$(printf '%s' "$name" | sed 's/[^a-z0-9_-]/_/g')"

	#conclusion
	name="$(printf '%s' "$name" | sed 's/__+/_/g')"

	# clean beg/end
	name="$(printf '%s' "$name" | sed 's/^[_-]*//; s/[_-]*$//')"

	# avoid empty name
	[[ -n "$name" ]] || name="unnamed"

	printf '%s\n' "$name"
}



create_launcher(){
	
	IsItDir "$DST_LAUNCHER" || install -d ${DST_LAUNCHER} 2>> "$ERR_LOG"
	IsItWrite "$DST_LAUNCHER" || return 1
	local filename="$PAR_launcher_profilename"
	local launcher_path="${DST_LAUNCHER}/${filename}.desktop"
	if cat > "$launcher_path" 2>> "$ERR_LOG" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=${PAR_launcher_name}
Comment=Launches ${PAR_launcher_name} browser based desktop-app
Exec=${PAR_browser} --new-instance -P ${PAR_launcher_profilename} ${PAR_launcher_url}
Icon=${PAR_launcher_icon}
Path=
Terminal=false
StartupNotify=false
EOF
	then
		OutOk_i "$TXT_CREATE_LAUNCHER_OK" "lst"
		printf "%s\n" "$launcher_path"
		return 0
	else
		OutErr_i "$TXT_CREATE_LAUNCHER_ERR" "lst"
		return 1
	fi	
}


set_checksum_xfce(){
	local launcher="$1"
	DebugLog "\$1 launcher: $launcher" "INFO" "$LINENO"
	
	IsItWrite "$launcher"
	if gio set -t string "$launcher" metadata::xfce-exe-checksum\
	 "$(sha256sum "$1" | awk '{print $1}')" 2>> "$ERR_LOG"
	then
		OutOk_i "$TXT_CHECKSUM_OK" "lst"
		return 0 
	else 
		OutErr_i "$TXT_CHECKSUM_ERR" "lst"
		return 1
	fi
}


val_checksum_xfce(){
	local launcher="$1" 
	DebugLog "\$1 launcher: $launcher"
	
	IsItRead "$launcher"
	local checksum="$( { gio info -a "metadata::xfce-exe-checksum" "$launcher" \
	| grep metadata::xfce-exe-checksum: \
	| awk '{print $2}'; } 2>>$ERR_LOG )"
	if [[ -n "$checksum" ]]; then
		OutOk_i "$TXT_CHECKSUMVAL_OK" "lst"
		return 0
	else
		OutErr_i "$TXT_CHECKSUMVAL_ERR" "lst"
		return 1
	fi
}

chmod_x(){
	local file="$1"
	DebugLog "\$1 file: $file" "$LINENO"
	
	IsItExist "$file"
	IsItWrite "$file"
	if chmod +x "$file" 2>>"$ERR_LOG"; then
		OutOk_i "$TXT_CHMODX_OK" "lst"
		return 0
	else
		OutErr_i "$TXT_CHMODX_ERR" "lst"
		OutWarn_i "$TXT_TRY"
		return 1
	fi
}

init(){
	DebugLog "$SCRIPT_NAME" "START" 
	
		local path_launcher
		load_config "${BASE_DIR}/lang/${PAR_lang}/txt_create_launcher.conf"
		
		Out " "
		Out_i "$TXT_CREATE_LAUNCHER $HIGHLIGHT$launcher_name$NC"
		path_launcher="$(create_launcher)"
		
		sleep 0.25
		
		set_checksum_xfce "$path_launcher" || exit 1
		val_checksum_xfce "$path_launcher" 
		chmod_x "$path_launcher"
		
		#---script Output------------#
			printf "%s\n" "$path_launcher"
		#---script Output------------#

		sleep 1
}

########################################################################
param_err=()
[[ -z "$PAR_lang" ]] && param_err+="LANG "
[[ -z "$PAR_browser" ]] && param_err+="BROWSER "
[[ -z "$PAR_launcher_profilename" ]] && param_err+="PROFILNAME "
[[ -z "$PAR_launcher_name" ]] && param_err+="NAME "
[[ -z "$PAR_launcher_icon" ]] && param_err+="ICON "
[[ -z "$PAR_launcher_url" ]] && param_err+="URL"

if (( ${#param_err[@]} > 0 )); then
	OutErr_i "$TXT_PARAM_ERR ${param_err[*]}"
	exit 1
fi


init
	
 


