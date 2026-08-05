#!/usr/bin/env bash 

#--------------- Self -------------------------------------------------#

BASE_DIR="$( dirname "$( realpath "${BASH_SOURCE[0]}" )" )"
SCRIPT_NAME="$(basename "$0")"

#-------------- Source: location --------------------------------------# 

#Source: scripts
SCRIPT_LANGSETTER="${BASE_DIR}/data/lang.sh"

#Source: functions
FUNC_CONFIGPARSER="${BASE_DIR}/data/func/configparser.sh"
FUNC_OUTPUT="${BASE_DIR}/data/func/output.sh"
FUNC_USERINPUT="${BASE_DIR}/data/func/userinput.sh"
FUNC_ISIT="${BASE_DIR}/data/func/isit.sh"

#Source: text
TEXT_DEFAULT="${BASE_DIR}/data/lang/en/txt_main.conf"
LOGO="${BASE_DIR}/data/logo.txt"


#-------------- Source: validation-------------------------------------#

#Source: validation scripts
bash -n "$SCRIPT_LANGSETTER" &> /dev/null || invalid_parts+=( "Invalid File: $SCRIPT_LANGSETTER line: ${LINENO[@]}" )

#Source: validation functions
bash -n "$FUNC_CONFIGPARSER" &> /dev/null || invalid_parts+=( "Invalid File: $FUNC_CONFIGPARSER line: ${LINENO[@]}" )
bash -n "$FUNC_OUTPUT" &> /dev/null || invalid_parts+=( "Invalid File: $FUNC_OUT PUTline: ${LINENO[@]}" )
bash -n "$FUNC_USERINPUT" &> /dev/null || invalid_parts+=( "Invalid File: FUNC_USERINPUT line: ${LINENO[@]}" )
bash -n "$FUNC_ISIT" &> /dev/null || invalid_parts+=( "Invalid File: FUNC_ISIT line: ${LINENO[@]}" )

#Source validation: Text
TXT_DEFAULT="${BASE_DIR}/data/script/lang/en/txt_main.conf"
#[[ -r "$TEXT_DEFAULT" ]] || invalid_parts+=( "Invalid File: $TEXT_DEFAULT  line: ${LINENO[@]}")
[[ -r "$LOGO" ]] || invalid_parts+=( "Invalid File: $LOGO line: ${LINENO[@]}")

#Source: Exit: 1 if invalids
(( ${#invalid_parts} > 0 )) && printf "%b\n" "${invalid_parts[@]}" && exit 1
unset invalid_parts


#-------------- Source: includation -----------------------------------# 
source "$FUNC_CONFIGPARSER"
source "$FUNC_OUTPUT"
source "$FUNC_USERINPUT"
source "$FUNC_ISIT"



#--------------- Define Defs ------------------------------------------#

DEF_LANG="en"
DEF_ERR_LOG="${BASE_DIR}/data/makemyapp.log"

DEF_SLEEPTIME_EXIT=2 
DEF_SLEEPTIME_FALLBACK=2

#--------------- Set Defs if unset ------------------------------------#

ERR_LOG="${ERR_LOG:-"$DEF_ERR_LOG"}"
PACKAGE_DIR="${PACKAGE_DIR:-"$DEF_PACKAGE_DIR"}"
SLEEPTIME_EXIT=${SLEEPTIME_EXIT:-$DEF_SLEEPTIME_EXIT}
SLEEPTIME_FALLBACK=${SLEEPTIME_FALLBACK:-$DEF_SLEEPTIME_FALLBACK}

############### FUNCTIONS ##############################################

logo=()
while IFS= read -r line; do
    logo+=("$line")
done < "$LOGO"

UserExit(){
	Out ""
	Out "$TXT_MENU_EXIT"
	sleep $SLEEPTIME_EXIT
	exit 0
}

#----------------------------------------------------------------------#
MenuHeader(){
	clear
	OutSleepLine "SIG"
	OutColorSwitchLineWise "$SIG" "$HIGHLIGHT" "${logo[@]}"
	OutSleepLine "SIG"
	sleep 1
	OutH1 "by install.sh@proton.me"
	sleep 0.5
	clear
}

DisplayMenuA(){
clear >&2
Menu_Header "$TXT_MENU_HEADER"
Out "\n"
Out "$TXT_MENU_A_INTRO"
Out "$TXT_MENU_A_RCOMMENDATION"
Out ""
Out "$TXT_MENU_A_QUESTION"
Out ""
Out "${HIGHLIGHT}[l]${NC} Librewolf \t\t\t\t ${HIGHLIGHT}[q]${NC} $TXT_MENU_QUIT"
Out "${HIGHLIGHT}[f]${NC} Firefox"
}

MenuB(){
	clear >&2
	Menu_Header "---MakeMyApp---"
	Out "\n"
	Out "$TXT_MENU_B_BROWSER1 ${HIGHLIGHT}${browser^}${NC} $TXT_MENU_B_BROWSER2"
	Out " "
	Out "${HIGHLIGHT}[y]${NC} $TXT_MENU_CONTINUE \t\t ${HIGHLIGHT}[q]${NC} $TXT_MENU_QUIT"
	Out "${HIGHLIGHT}[n]${NC} $TXT_MENU_NEWCHOICE"
	Out "" 
}


MenuChooseBrowser(){
local browser

while true; do
		DisplayMenuA
		case $( ReturnUserInput ) in
				l|ll|L|LL) printf -v "browser" "librewolf";;
				f|ff|F|FF )printf -v "browser" "firefox";;
				q|qq|Q|QQ) UserExit
				;;
				*)
					OutLineErr
					OutErr "$TXT_MENU_INVALIDCHOICE"
					sleep 2
					continue
				;;
		esac

		MenuB

		case $( UserInputYNQ ) in
			y)
			break
			;;
			q)
			UserExit
			;;
		esac
		
		OutDeleteFromToEnd 11
	done
	printf "%s" "$browser"
	
}


init(){
	
	TEXT_SOURCE="${BASE_DIR}/data/lang/$lang/txt_main.conf"
	LoadOrFallback "$TEXT_SOURCE" "$TEXT_DEFAULT"

	MenuHeader
	browser="$( MenuChooseBrowser )"
	DebugLog "browser:$browser" "INFO"
	if [[ "$browser" == "librewolf" ]]; then
		if ! IsItInstalled "librewolf"; then
			OutErr "$TXT_MISSING_LW"
			sleep $SLEEPTIME_EXIT
			exit 1
		fi
	elif [[ "$browser" == "firefox" ]]; then
		if ! IsItInstalled "firefox"; then
			OutErr "$TXT_MISSING_FF"
			sleep $SLEEPTIME_EXIT
			exit 1
		fi
	else
		exit 1
	fi
	
	exec bash "$BASE_DIR/data/install.sh" "$lang" "$browser"
}

#----------------------------------------------------------------------#
lang="$( bash "$SCRIPT_LANGSETTER" )"
lang="${lang:-"$DEF_LANG"}" #fallback


init


