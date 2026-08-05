#!/usr/bin/env bash
PAR_lang="$1"
PAR_package="$2"

#--------------- Self -------------------------------------------------#
BASE_DIR="$( dirname "$( realpath "${BASH_SOURCE[0]}" )" )"
SCRIPT_NAME="$(basename "$0")"

#-------------- Source: location --------------------------------------# 
#Source Config
#CONFIG_MAIN="${BASE_DIR}/lang/$PAR_lang/txt_package_manager.conf"

#Source: functions
SOURCE_CONFIGPARSER="${BASE_DIR}/func/configparser.sh"
SOURCE_OUTPUT="${BASE_DIR}/func/output.sh"
SOURCE_ISIT="${BASE_DIR}/func/isit.sh"

#Source: text
TEXT_DEFAULT="${BASE_DIR}/lang/en/txt_package_manager.conf"
TEXT_SOURCE="${BASE_DIR}/lang/$PAR_lang/txt_package_manager.conf"

#-------------- Source: validation-------------------------------------#
#Source: validation config
#main-config not implemented yet 

#Source: validation functions
bash -n "$SOURCE_CONFIGPARSER" &> /dev/null || invalid_parts+=( "Invalid File: $SOURCE_CONFIGPARSER\n")
bash -n "$SOURCE_OUTPUT" &> /dev/null || invalid_parts+=( "Invalid File: $SOURCE_OUTPUT\n")
bash -n "$SOURCE_ISIT" &> /dev/null || invalid_parts+=( "Invalid File: $SOURCE_ISIT\n")

#Source validation: Text
[[ -r "$TEXT_DEFAULT" ]] || invalid_parts+=( "Invalid File: $TEXT_DEFAULT line: ${LINENO[@]}")

(( ${#invalid_parts} > 0 )) && printf "%b" "${invalid_parts[*]}" && exit 1

#-------------- Source: includation -----------------------------------#
source "${BASE_DIR}/func/configparser.sh"
source "${BASE_DIR}/func/output.sh"
source "${BASE_DIR}/func/isit.sh"

#--------------- Define Defs ------------------------------------------#

DEF_TXT_PAR_ERR="Parameter missing!"
DEF_LOG="${BASE_DIR}/makemyapp.log"

#--------------- Set Defs if unset ------------------------------------#

TXT_PAR_ERR="${TXT_PAR_ERR:-$DEF_TXT_PAR_ERR}"
ERR_LOG="${ERR_LOG:-$DEF_LOG}"

############### FUNCTIONS ##############################################
#ensure key is known and has a value

IsKeyValue(){
	local key="$1"
	local value="$2"
	DebugLog "key: $key; value: $value" "INFO" 
	
	[[ "$key" == "SCOPEADDON" ]] && return 0
		if [[ -z "$value" ]]; then
			OutErr_i "$TXT_EMPTY_KEYVALUE ($key) $value" "lst"
			return 1
		fi 
	}
	
IsKeyKnown(){
	local key="$1"
	DebugLog "key: $key" "INFO" 
	
	case $key in
		APPNAME|ICON|URL|SCOPEADDON)
			return 0
		;;
		*) 
			OutErr_i "$TXT_UNKNOW_KEY $key" "lst"
			return 1
		;;
		esac
}

ValidateKeysAndValues(){
		local key="$1"
		local value="$2"
		DebugLog "key: $key; value:$value"  "INFO" 

		IsKeyKnown "$key" || return 1
		IsKeyValue "$key" "$value" || return 1 
		}

CodeScore(){
	local text="$1"
	local score=0
	local regex

	#Control flow / language constructs
	regex='(^|[^[:alnum:]_])(if|else|elif|elseif|for|foreach|while|do|switch|case|match|try|catch|return|function|class)([^[:alnum:]_]|$)'
	[[ "$text" =~ $regex ]] && ((score++))

	#Typical brackets
	regex='[{}()]'
	[[ "$text" =~ $regex ]] && ((score++))

	#Typical operators
	regex='(==|!=|=>|<=|>=|:=|\+\+|--)'
	[[ "$text" =~ $regex ]] && ((score++))

	#Semikolon
	regex=';'
	[[ "$text" =~ $regex ]] && ((score++))

	printf '%d' "$score"
}

ReadAndValidatePackageConf() {
    local file="$1/makemyapp.conf"
    local line
    local codescore
    local key
    local value 
    local keyvalues
	local -a keys=()
	local -a keys=()
	DebugLog "file: $file;" "INFO" 
	
	codescore=0
    while IFS= read -r line || [[ -n "$line" ]]; do
        #check line for code
		codescore=$(( $code_score + $(CodeScore "$line") ))
		(( codescore < 2 )) || return 1
		
        # skip comments and empty lines
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
		
        #force key = value
        if [[ "$line" =~ ^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]]; then
            key="${BASH_REMATCH[1]}"
            value="${BASH_REMATCH[2]}"
          
			#delete quotes from values
            value="${value%\"}"
            value="${value#\"}"
			
			keys+=("$key")
			values+=("$value")
			
			keys+=("$key")
			values+=("$value")
			keyvalues="${keyvalues}\n\t${key}\t\t\t${value}"
			
			#ensure key is known and has a value
			if ! ValidateKeysAndValues "$key" "$value"; then
				DebugLog "keyvalues: $keyvalues" "ERROR"
				return 1
			fi
			
        else
			DebugLog "keyvalues: $keyvalues;" "Error"
			OutErr_i "$TXT_INVALID_CONFIGLINE $line" "lst" >&2
            return 1
        fi
    done < "$file"
    DebugLog "keyvalues: $keyvalues;" "INFO"
  }  
  
#---------------Validation: Package -----------------------------------#

IsConfIn(){
	local package_root="$1"
	local config="$package_root/makemyapp.conf"
	local mime
	DebugLog "package_root: $package_root" "INFO"
	
	if ! IsItFile "$config"; then
		OutErr_i "$TXT_CONF_MISSING" "lst"
		return 1
	fi
	
	if ! IsType "$config" "text/plain"; then
		OutErr_i "$TXT_CONF_WRONGTYPE"
		return 1
	fi
		
}

IsLogoIn(){
	local package_root="$1" #path
	local logo="$package_root/logo.svg"
	DebugLog "package_logo: $logo" "INFO"
	
	if ! IsItFile "$logo"; then 
		OutErr_i "$TXT_LOGO_MISSING" "lst"
		return 1
	fi
	
	if ! IsType "$logo" "image/svg+xml"; then
		OutErr_i "$TXT_LOGO_WRONGTYPE" "lst"
		return 1
	fi
	
}
IsUserjsIn(){
	local package_root="$1" #path
	local userjs="$package_root/user.js"
	DebugLog "userjs:$$userjs" "INFO"
	
	
	if ! IsItFile "$userjs"; then 
		OutErr_i "$TXT_USERJS_MISSING" "lst"
		return 1
	fi
	
	if ! IsType "$userjs" "text/plain"; then
		OutErr_i "$TXT_USERJS_WRONGTYPE" "lst"
		return 1
	fi
}

IsExtensionIn(){
	local package_root="$1"
	DebugLog "package_root: $package_root" "INFO"
	
	if ! IsItDir "$package_root/extensions"; then
		OutErr_i  "$TXT_EXTE_MISSING" "lst"
		return 1
	fi
}

IsChromeIn(){
	local package_root="$1" #path
	DebugLog "package_root: $package_root" "INFO"
	
	if ! IsItDir "$package_root/chrome"; then
		OutErr_i "$TXT_CHRO_MISSING" "lst"
		return 1
	fi
}

IsUserChromeIn(){
	local package_root="$1" #path
	local userchromecss="$package_root/chrome/userChrome.css"
	DebugLog "package_root: $package_root" "INFO"
	
	if ! IsItFile "$userchromecss"; then 
		OutErr_i "$TXT_USCH_MISSING" "lst" 
		return 1
	fi
	
	if ! IsType "$userchromecss" "text/plain"; then
		OutErr_i "$TXT_USCH_WRONGTYPE"
		return 1
	fi
}

IsType() {
    local path="$1"
    local expected="$2"
    local actual

    [[ -f "$path" ]] || return 1

    actual=$( file --brief --mime-type -- "$path" )
	DebugLog "path:$path; expected:$expected actual:$actual" "INFO"
    case "$actual" in
        "$expected") return 0 ;;
        *) OutErr "!!!!!" && return 1 ;;
    esac
}


IsPackageComplete(){
	local package="$1" #path
	
	packagename="$( basename "$package" )"
	DebugLog "tmpd: $tmpd; packagename: $( basename $packagename )" "INFO"  "$LINENO"
	
	IsConfIn "$package" || STATE="ERROR"
	# IsUserjsIn "$package"  || STATE="ERROR"
	IsExtensionIn "$package"  || STATE="ERROR"
	IsChromeIn "$package" && IsUserChromeIn "$tmpd" || STATE="ERROR"
	IsLogoIn "$package" || STATE="ERROR"
	if [[ "$STATE" == "ERROR" ]]; then
		OutErr_i "$TXT_PACKAGE_NOTCOMPLETE" "lst"
		sleep 2
		return 1
	else
		OutOk_i "$TXT_PACKAGE_COMPLETE" "lst"
	fi
}

CodeScore(){
	local text="$1"
	local score=0
	local regex

	#Control flow / language constructs
	regex='(^|[^[:alnum:]_])(if|else|elif|elseif|for|foreach|while|do|switch|case|match|try|catch|return|function|class)([^[:alnum:]_]|$)'
	[[ "$text" =~ $regex ]] && ((score++))

	#Typical brackets
	regex='[{}()]'
	[[ "$text" =~ $regex ]] && ((score++))

	#Typical operators
	regex='(==|!=|=>|<=|>=|:=|\+\+|--)'
	[[ "$text" =~ $regex ]] && ((score++))

	#Semikolon
	regex=';'
	[[ "$text" =~ $regex ]] && ((score++))

	printf '%d' "$score"
}




#----------------------------------------------------------------------#
ListPackageDir(){
	local tmpd="$1"
	local files
	files="$( find "$tmpd" -mindepth 1 -maxdepth 3 2>> "$ERR_LOG" )" 
	DebugLog "Ftemp: $tmpd; files: $files"
}

ExtractTarToTmp(){
	local package="$1" #path
	local dsc="$2" #path
	
	DebugLog "package: $package; dsc: $dsc" "INFO"  "$LINENO"
	
	if ! tar -xf "$package" -C "$tmpd" 2>> $ERR_LOG; then
		OutErr "$TXT_FAILED_XTRACTION1 $tmpd $TXT_FAILED_XTRACTION2"
		STATE="ERR"
		return 1
	fi
	OutOk_i "$TXT_EXRRACTRION_OK" "lst"
	DebugLog "$package extracted to: $dsc"
}

IsTempReady(){
	local tmpd="$1" #path
	DebugLog "\$1 tmpd: $tmpd" "INFO"  "$LINENO"
	
	if ! IsItExist "$tmpd"; then
		OutErr_i "$TXT_MISSING_TMPD $tmpd" "lst"
		return 1
	fi
	if ! IsItWrite "$tmpd"; then
		OutErr_i "$TXT_MISSING_WR $tmpd" "lst"
		return 1
	fi
}


#extracts package.zip to tempdir, validates package, returns path tmpdir
init(){
	local tmpd
	LoadOrFallback "$TEXT_SOURCE" "$TEXT_DEFAULT"
	
	DebugLog "$SCRIPT_NAME" "START"
	tmpd="$(mktemp -d 2>> $ERR_LOG )" || return 1
	IsTempReady "$tmpd" || return 1
	
	ExtractTarToTmp "$PAR_package" "$tmpd" || return 1
	#ListPackageDir "$tmpd" #debug
	IsPackageComplete "$tmpd" || return 1
	#IsConfigValide
	ReadAndValidatePackageConf "$tmpd" || return 1
	
	#----- script Output ----#
	
	printf "%s" "$tmpd" #path
	DebugLog "Output temp path: $tmpd" "END" "$LINENO" "END"
	
	return 0
	#----- script Output ----#
	
	}
########################################################################
	
	if [[ -z $PAR_package ]]; then
		OutErr "${SCRIPT_NAME}: $TXT_PAR_ERR \$2:package"
		exit 1
		
	fi
	
	DebugLog "PAR_Lang: $PAR_lang PAR_package: $PAR_package" "START"  "$LINENO"
	init 
