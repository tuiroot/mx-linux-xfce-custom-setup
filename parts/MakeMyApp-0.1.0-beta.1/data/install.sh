#!/usr/bin/env bash
PAR_lang="$1"
PAR_browser="$2"
#--------------- Self -------------------------------------------------#

BASE_DIR="$( dirname "$( realpath "${BASH_SOURCE[0]}" )" )"
SCRIPT_NAME="$(basename "$0")"

#-------------- Source: location --------------------------------------#  

#Source Config 
#CONFIG_MAIN="#main-config not implemented yet "

#Source: scripts
SCRIPT_PACKAGE_MANAGER="${BASE_DIR}/package_manager.sh"
SCRIPT_CREATOR_LAUNCHER="${BASE_DIR}/creator_launcher.sh"

#Source: functions
FUNC_CONFIGPARSER="${BASE_DIR}/func/configparser.sh"
FUNC_OUTPUT="${BASE_DIR}/func/output.sh"
FUNC_USERINPUT="${BASE_DIR}/func/userinput.sh"
FUNC_ISIT="${BASE_DIR}/func/isit.sh"

#Source: text
TEXT_DEFAULT="${BASE_DIR}/lang/en/txt_install.conf"
[[ -n "$PAR_lang" ]] && TEXT_SOURCE="${BASE_DIR}/lang/$PAR_lang/txt_install.conf"

#-------------- Source: validation-------------------------------------# 

#Source: validation config:
#main-config not implemented yet 

#Source: validation scripts)
bash -n "$SCRIPT_PACKAGE_MANAGER" &> /dev/null || invalid_parts+=( "Invalid File: $SCRIPT_PACKAGE_MANAGER  line: ${LINENO[@]}")
bash -n "$SCRIPT_CREATOR_LAUNCHER" &> /dev/null || invalid_parts+=( "Invalid File: $SCRIPT_CREATOR_LAUNCHER  line: ${LINENO[@]}")

#Source: validation functions
bash -n "$FUNC_CONFIGPARSER" &> /dev/null || invalid_parts+=( "Invalid File: $FUNC_CONFIGPARSER line: ${LINENO[@]}")
bash -n "$FUNC_OUTPUT" &> /dev/null || invalid_parts+=( "Invalid File: $FUNC_OUTPUT line: ${LINENO[@]}")
bash -n "$FUNC_USERINPUT" &> /dev/null || invalid_parts+=( "Invalid File: FUNC_USERINPUT line: ${LINENO[@]}")
bash -n "$FUNC_ISIT" &> /dev/null || invalid_parts+=( "Invalid File: $FUNC_ISIT line: ${LINENO[@]}")

#Source validation: Text
[[ -r "$TEXT_DEFAULT" ]] || invalid_parts+=( "Invalid File: $TEXT_DEFAULT line: ${LINENO[@]}")

#Source: Exit: 1 if invalids
(( ${#invalid_parts} > 0 )) && printf "%b\n" "${invalid_parts[@]}" && exit 1

#-------------- Source: includation -----------------------------------#

#Source: includation func
source "$FUNC_CONFIGPARSER"
source "$FUNC_OUTPUT"
source "$FUNC_USERINPUT"
source "$FUNC_ISIT"

#--------------- Define Defs ------------------------------------------#

DEF_LANG="en"
DEF_BROWSER="librewolf"
DEF_ERR_LOG="${BASE_DIR}/makemyapp.log"
DEF_PACKAGE_DIR="packages"
DEF_BROWSER_DIR_LW="${XDG_CONFIG_HOME}/librewolf/librewolf"
DEF_BROWSER_DIR_FF="${XDG_CONFIG_HOME}/mozilla/firefox"
DEF_PACKAGE_CONFIGNAME="makemyapp.conf"
DEF_SLEEPTIME_BROWSERINIT=5
DEF_SLEEPTIME_EXIT=2 
DEF_SLEEPTIME_PROFILE_CREATED="0.5"
DEF_SLEEPTIME_FALLBACK=2

#--------------- Set Defs if unset ------------------------------------#

ERR_LOG="${ERR_LOG:-"$DEF_ERR_LOG"}"
PACKAGE_DIR="${PACKAGE_DIR:-"$DEF_PACKAGE_DIR"}"
BROWSER_DIR="${BROWSER_DIR:-"$DEF_BROWSER_DIR_LW"}"
BROWSER_DIR_LW="${BROWSER_DIR_LW:-"$DEF_BROWSER_DIR_LW"}"
BROWSER_DIR_FF="${BROWSER_DIR_FF:-"$DEF_BROWSER_DIR_FF"}"
PACKAGE_CONFIGNAME="${PACKAGE_CONFIGNAME:-$DEF_PACKAGE_CONFIGNAME}"
SLEEPTIME_PROFILE_CREATED=${SLEEPTIME_PROFILE_CREATED:-$DEF_SLEEPTIME_PROFILE_CREATED}
SLEEPTIME_BROWSERINIT=${SLEEPTIME_BROWSERINIT:-$DEF_SLEEPTIME_BROWSERINIT}
SLEEPTIME_EXIT=${SLEEPTIME_EXIT:-$DEF_SLEEPTIME_EXIT}
SLEEPTIME_FALLBACK=${SLEEPTIME_FALLBACK:-$DEF_SLEEPTIME_FALLBACK}

############### FUNCTIONS ##############################################
UserExit(){
	Out ""
	Out "MakeMyApp wird beendet..."
	sleep $SLEEPTIME_EXIT
	exit 0
}

BrowserMod(){
	local tmpd_package="$1"
	local path_profile="$2"
	
	source="$tmpd_package/user.js"
	target="$path_profile/user.js"
	MoveFile "$source" "$target" || return 1
	
	source="$tmpd_package/extensions/"
	target="$path_profile/"
	MoveFile "$source" "$target" || return 1
	
	source="$tmpd_package/chrome/"
	target="$path_profile/"
	MoveFile "$source" "$target" || return 1

}


CopyFiles(){
	local src="$1"
	local dst="$2"; dst="${dst%/}"
	DebugLog "src:$src dst:$dst" "INFO" 
	
	IsItExist "$src" || return 1
	IsItDir "$dst" || return 1
	IsItWrite "$dst" || return 1
	cp -r "$src" "$dst" >/dev/null 2>> "$ERR_LOG"
}

MoveFile(){
	local src="$1"
	local dst="$2"; dst="${dst%/}"
	DebugLog "src:$src dst:$dst" "INFO" 
	
	IsItExist "$src" || return 1
	IsItDir "$( dirname "$dst" )" || return 1
	IsItWrite "$( dirname "$dst" )" || return 1
	mv "$src" "$dst" >/dev/null 2>> "$ERR_LOG"
}


#returns array with paths
ScanPackageDir(){
	local arrname="$1" #Array name 
	DebugLog "arrname: $arrname" "INFO" 
	
	#global array
	mapfile -t "$arrname" < <(
	find "${BASE_DIR}/${PACKAGE_DIR}" -mindepth 1 -maxdepth 1 -type f -name "*.tar" 2>> "$ERR_LOG";
	)
		
}

#starts a librewolf headless session
InitBrowserProfile(){
	local browser="$1"
	local profile="$2"
	DebugLog "profile: $profile" "INFO" 
	
	{ "$browser" -P "$profile" --headless; } >> "$ERR_LOG" 2>&1 &
	pid=$!
	if kill -0 "$pid" 2>> "$ERR_LOG"; then
		return 0
	else
		return 1
	fi
}

CookieExceptions() {
local path="$1"
local url="$2"
local sqlfile="$path/permissions.sqlite"
local SQL

DebugLog "path:$path; url:$url sqlfile:$sqlfile"

IsItDir "$path" || return 1
IsItFile "$sqlfile" || return 1
IsItWrite "$sqlfile" || return 1

SQL="
INSERT INTO moz_perms
(origin, type, permission, expireType, expireTime, modificationTime)
VALUES
(
    '$url',
    'cookie',
    1,
    0,
    0,
    CAST(strftime('%s', 'now') AS INTEGER) * 1000
);"

sqlite3 "$sqlfile" "$SQL" &>> "$ERR_LOG"
}

#stop headless librewolf instance
StopBrowserSession(){
	local browser="$1"
	local profile="$2"
	
	DebugLog "browser:$browser; profile:$profile" "INFO"
	
	if pkill -f "${browser}.*$profile" 1> /dev/null 2>> "$ERR_LOG"; then
		OutOk_i "$TXT_STOP_PROF_OK" "lst"
		return 0
	else
		OutErr_i "$TXT_STOP_PROF_ERR" "lst"
		OutWarn_i "${TXT_WARN["stop_profile"]}"
		return 1
	fi
}




#checks if firefox generated a profile dir
ProfileExists(){
	local browser_dir="$1"
	local profile="$2"
	
	local path_profile
	DebugLog "profile:$profile" "INFO"  
	
	path_profile="$(find "$browser_dir" -name "*.${profile}" 2>> "$ERR_LOG")"
	[[ -n "$path_profile" ]] || return 1
}


#creates librewolf profile, checks succes and returns profile-path
CreateBrowserProfile(){
	local browser="$1"
	local browser_dir="$2"
	local profile="$3"
	
	local path_profile
	DebugLog "\$1 profile: $profile" "INFO"  
	
	"$browser" -CreateProfile "$profile" 2>> "$ERR_LOG"
	sleep $SLEEPTIME_PROFILE_CREATED 
	
	#check success
	path_profile="$(find "$browser_dir" -name "*.${profile}" 2>> "$ERR_LOG")"
	[[ -n $path_profile ]] || return 1
	printf "%s\n" "$path_profile"
}

#converts APPNMAE from makemyapp.conf into ff profilnames
convert_name(){
	local input="$1"
	local name
	DebugLog "\$1 input: $input" "INFO"  
 
	name="${input,,}"
	name="${name//ä/ae}"
	name="${name//ö/oe}"
	name="${name//ü/ue}"
	name="${name//ß/ss}"

	# replace unwanted
	name="$(printf '%s' "$name" | sed 's/[^a-z0-9_-]/_/g')"

	# Mehrere _ zusammenfassen
	name="$(printf '%s' "$name" | sed 's/__+/_/g')"

	# clean beg/end
	name="$(printf '%s' "$name" | sed 's/^[_-]*//; s/[_-]*$//')"

	# Leerer Name verhindern
	[[ -n "$name" ]] || name="unnamed"

	printf '%s\n' "$name"
}



#------------- Menu ---------------------------------------------------#

DisplayMenuA(){
clear
Menu_Header "$TXT_MENU_HEADER"
Out "\n"
Out "$TXT_MENU_INTRO1 ${HIGHLIGHT}$TXT_MENU_INTRO2${NC} $TXT_MENU_INTRO3"
Out ""
Out "$TXT_MENU_INFO" 
Out ""
Out "$TXT_MENU_QUESTION"
Out ""
Out "${HIGHLIGHT}[y]${NC} $TXT_MENU_CONTINUE \t\t ${HIGHLIGHT}[q]${NC} ${TXT_MENU_QUIT}"
Out "${HIGHLIGHT}[b]${NC} ${TXT_MENU_BROWSERCHOICE}"
Out ""
}

DisplayMenuB(){
	clear
	Menu_Header "$TXT_MENU_HEADER"
	Out "\n"
	Out "$TXT_MENU_PACKAGES_FOUND ${SIG}[- ${#PACKAGES[@]} -]${NC}" 
	Out ""
	OutListFourColumns "${PACKAGES[@]}"
	Out ""
	Out "$TXT_MENU_HOWTO ${HIGHLIGHT}${TXT_MENU_HOWTO1}${NC} $TXT_MENU_HOWTO2 ${HIGHLIGHT}$TXT_MENU_HOWTO3${NC} " #export
}

DisplayMenuC(){
	Out "\n"
	Out "$TXT_MENU_ASKSCOPE"
	OutWarn "$TXT_MENU_INFO_SCOPE"
	Out " "
	Out "${HIGHLIGHT}[y]${NC} $TXT_MENU_CHOICE_SCOPE \t\t ${HIGHLIGHT}[q]${NC} $TXT_MENU_QUIT" 
	Out "${HIGHLIGHT}[n]${NC} $TXT_MENU_CHOICE_NOSCOPE"
}

DisplayMenuD(){
	Out "\n"
	Out "$TXT_MENU_START_APP"
	Out " "
	Out "${HIGHLIGHT}[y]${NC} $TXT_MENU_START_APP_Y \t\t ${HIGHLIGHT}[q]${NC} $TXT_MENU_QUIT" 
	Out "${HIGHLIGHT}[n]${NC} $TXT_MENU_START_APP_N" 
}


DisplayMenuE(){
Out ""
Out "$TXT_MENU_ASKAPPS"
Out ""
Out "${HIGHLIGHT}[y]${NC} $TXT_MENU_ASKAPPS_Y \t\t ${HIGHLIGHT}[q]${NC} $TXT_MENU_QUIT"
Out "${HIGHLIGHT}[n]${NC} $TXT_MENU_ASKAPPS_N"
Out ""
}

#--------------Loop
DisplayUserInfoA(){
	Out " "
	Out "${TXT_USERINFO_A}: $HIGHLIGHT$( basename "$element" )$NC..."
}


DisplayUserInfoB() {
	Out " "
	Out "${TXT_USERINFO_B}: $HIGHLIGHT $APPNAME $NC" 
	Out_i "$TXT_CREATE_PROF_LW"
}

DisplaySummary(){
		Out " "
		Out "$TXT_APP_CREATED_OK ${HIGHLIGHT}${APPNAME}${NC}"
		Out " "
		if [[ "$STATE" == "OK" ]]; then
			Out "$TXT_APP_LAUNCHER ${HIGHLIGHT}$path_launcher${NC}"
		elif [[ "$STATE" == "WARN" ]]; then
			OutWarn "$TXT_APP_CREATED_WARN"
		fi
}

#----------------------------------------------------------------------#
MenuA(){
	DisplayMenuA
	while true; do
		case "$( ReturnUserInput )" in
			y|yy|Y|YY) break ;;
			b|bb|B|BB) exec bash "${BASE_DIR}/../makemyapp.sh" ;;
			q|qq|Q|QQ) UserExit ;;
			*) OutErr "$TEXT_MENU_INVALIDCHOICE"
		esac
	done

}

MenuB(){
	DisplayMenuB
	mapfile -t "Choice" < <( UserInputMultiSelect "${PACKAGES[@]}")

	case ${Choice[@]} in
		quit)
			UserExit
		;;
	esac
}


MenuC(){
	while true; do
		DisplayMenuC
		case "$( UserInputYNQ )" in
				y) 
				scope_install="y"
				break
				 ;;
				n) 
				scope_install="n"
				break
				;;
				q) UserExit ;;
		esac
	done
	OutDeleteRowsAbove 7
}

MenuD(){
	while true; do	
		DisplayMenuD
			case $( UserInputYNQ ) in
				y)	
					DebugLog "$browser-App $APPNAME started with $browser_profile" "INFO"
					{ "$browser" --new-instance -P "$browser_profile" "$URL"; } &>/dev/null
					break
				;;
				n) break	;;
				q) UserExit ;;
			esac
	done
	OutDeleteRowsAbove "5"
}

MenuE(){
	while true; do
		DisplayMenuE
			case "$( UserInputYNQ )" in
				y) break ;;
				n) exec bash "${BASE_DIR}/../makemyapp.sh" ;;
				q) UserExit ;;
			esac
		OutDeleteRowsAbove "5"
	done
}

############### MAIN ###################################################
								
#Source: set source txt/lang

init(){
	local lang="$1"
	DebugLog "$SCRIPT_NAME" "START" 
	
	#load text  
	TEXT_SOURCE="${BASE_DIR}/lang/$lang/txt_install.conf"
	LoadOrFallback "$TEXT_SOURCE" "$TEXT_DEFAULT"

#-----------------------------------------------------------------------#start main loop
while true; do 
	
	MenuA
	
	ScanPackageDir "PACKAGES"
	if (( ${#PACKAGES[@]} < 1 )); then
		STATE="ERR"
		OutErr_i "$TXT_NOPACKAGES_ERR"
		sleep "$SLEEPTIME_EXIT"
		exit 1
	fi
	
	MenuB

#-----------------------------------------------------------------------#start package loop
for element in "${Choice[@]}"; do
	STATE="START"
	StateLine
	((i++))

	DebugLog "For loop: $i; element: $element" "START"  
	
	DisplayUserInfoA
	sleep 2
	#-------------------------------------------------------------------#Extract Package
	
	#Script Manager returns temp with extracted and validatet files
	if ! tmpd_package="$( bash "$SCRIPT_PACKAGE_MANAGER" "$lang" "$element")"; then
		STATE="ERR"
		OutWarn "\n${TXT_PACKAGE_ERR}"
		StateLine
		continue
	fi
	
	sleep 1
	STATE="OK"
	
	OutOk_i "$TXT_PACKAGE_OK" "lst"
		
	#-------------------------------------------------------------------#load Package config
	
	tmpd_package_conf="${tmpd_package}/$PACKAGE_CONFIGNAME"
	DebugLog "For loop: $i; temp: $tmpd_package_conf" "INFO"  
	
	#load: APPNAME, ICON, URL, SCOPEADDON
	if ! load_config "$tmpd_package_conf"; then
		OutErr_i "$TXT_PCONF_ERR" "lst"
		STATE="ERR"
		StateLine
		continue
	fi
	STATE="OK"
	
	#-------------------------------------------------------------------#Reask Scopeaddon
	
	if [[ -n "$SCOPEADDON" ]]; then
		MenuC
	fi
	
	
	#-------------------------------------------------------------------#Namespace check
	DisplayUserInfoB
	
	browser_profile="$(convert_name "$APPNAME")"
	
	#CheckAppExists "$profil_name_ff" || continue
	if ProfileExists  "$BROWSER_DIR" "$browser_profile"; then
		OutErr_i "$TXT_PROFILE_EXISTS" "lst"
		STATE="ERR"
		StateLine
		continue
	fi
	STATE="OK"
	OutOk_i "$TXT_PROFILE_NOTEXISTS" "lst"
	
	#-------------------------------------------------------------------#Create Profile
	
	#Script call creates launcher and returns path
	if ! path_profile="$( CreateBrowserProfile "$browser" "$BROWSER_DIR" "$browser_profile" )"; then
		STATE="ERR"
		OutErr_i "$TXT_CREATE_PROF_ERR" "lst"
		StateLine
		continue
	fi
	STATE="OK"
	OutOk_i "$TXT_CREATE_PROF_OK" "lst"	
	
	#------------------------------------------------------------------#Install browser mods
	
	#copy themes and addons to profile dir
	source="$tmpd_package"
	target="$path_profile"
	
	if ! BrowserMod "$source" "$target"; then
		STATE="ERR"
		OutErr_i "$TXT_ADDON_COPY_ERR $target" "lst"
		StateLine
		continue
	fi
	STATE="OK"
	OutOk_i "$TXT_ADDON_COPY_OK" "lst"
		
	#install scopeaddon
	if [[ "$scope_install" == "y" ]]; then
		path_userjs="$path_profile/user.js"
		printf '%s\n' 'user_pref("extensions.autoDisableScopes", 14);' >> "$path_userjs"
		OutOk_i "$TXT_USERINFO_SCOPEADDON" "lst"
	fi
	
	#------------------------------------------------------------------#Init Profile
	
	#start librewolf headless to init profile
	if ! InitBrowserProfile "$browser" "$browser_profile"; then
		STATE="ERR"
		OutErr_i "$TXT_INIT_PROF_ERR" "lst"
		StateLine
		continue
	fi
	STATE="OK"
	OutOk_i "$TXT_INIT_PROF_OK" "lst"
	
	#wait for browser is done
	sleep "$SLEEPTIME_BROWSERINIT"
	DebugLog "5sec sleep" "INFO" 
	
	#------------------------------------------------------------------#stop profile
	
	#stop headless librewolf instancey
	StopBrowserSession "$browser" "$browser_profile"  || continue
	sleep 1
	#------------------------------------------------------------------#remove scopeaddon_edit
	
	if [[ "$scope_install" == "y" ]]; then
		sed -i '$d' "$path_userjs"
	fi
	
	#------------------------------------------------------------------#set cookie exception for App Url
	
	if ! CookieExceptions "$path_profile" "$URL"; then
		STATE="WARN"
		OutWarn_i "Cookie Management für App konnte nicht gesetzt werden" "lst"
	else
		STATE="OK"
		OutOk_i "Cookie Ausnahme für App gesetzt" "lst"
	fi
	
	#--------------------------------------------------------------------Prepare launcher icon
	
	source="$tmpd_package/logo.svg"
	target="/usr/share/icons/$ICON.svg"
	
	if ! MoveFile "$source" "$target"; then
		STATE="WARN"
		OutWarn "App Icon konnte dem Systemordner nicht hinzugefügt werden" "lst"
		StateLine
	else
		STATE="OK"
		OutOk_i "App Icon vorbereitet" "lst"
	fi
		
	
	
	#------------------------------------------------------------------#Create launcher
	
	#Create a launcher for current Profile
	if ! path_launcher="$( bash "$SCRIPT_CREATOR_LAUNCHER" \
	"$lang" "$browser" "$browser_profile" "$APPNAME" "$ICON" "$URL")"; then
		OutWarn "\n $TXT_APP_CREATED_ERR" "lst" 
		STATE="WARN"
	fi 
	StateLine
	DisplaySummary
	
	#------------------------------------------------------------------#Start app?
	MenuD
	STATE="DEFAULT"	
	Out
	
	DebugLog "Loop $i finished"	"END" 
done
#-----------------------------------------------------------------------#End  package loop

	STATE="DEFAULT"
	StateLine

#-----------------------------------------------------------------------#Exit/Continue?
	MenuE

done
#-----------------------------------------------------------------------#End main loop
}


#------------------------------------------------------------------------#init

#parameters/globals
lang="${PAR_lang:-$DEF_LANG}" #fallback
browser="${PAR_browser:-$DEF_BROWSER}"


if [[ "$browser" == "librewolf" ]]; then
	BROWSER_DIR="$BROWSER_DIR_LW"
elif [[ "$browser" == "firefox" ]]; then
	BROWSER_DIR="$BROWSER_DIR_FF"
fi

init "$lang"
