#!/usr/bin/env bash

#---------------  defaults --------------------------------------------#
DEF_TXT_USER_ASK="Continue with the selected options?"
DEF_TXT_USER_CHOICE_CONT="Continue"
DEF_TXT_USER_CHOICE_EXIT="Exit MakeMyApp"
DEF_TXT_USER_CHOICE_NEW="Make a new selection"

TXT_USER_ASK="${TXT_USER_ASK:-$DEF_TXT_USER_ASK}"
TXT_USER_CHOICE_CONT="${TXT_USER:-$DEF_TXT_USER_CHOIE_CONT}"
TXT_USER_CHOICE_EXIT="${TXT_USER:-$EF_TXT_USER_CHOICE_EXIT}"
TXT_USER_CHOICE_NEW="${TXT_USER:-$DEF_TXT_USER_CHOICE_NEW}"

#----------------------------------------------------------------------#
ReadUserInput(){
	STATE="DEFAULT"
	local varname="$1"
	
	printf "\n%b" "$HIGHLIGHT" >&2
	read -rp "==> " -a "$varname"
	printf "%b" "$NC" >&2
	OutDeleteRowsAbove	"2"
	StateLine 
}

# to delete to delete to delete to delete to delete to delete
ReturnUserInput(){
	STATE="DEFAULT"
	local var
	
	printf "\n%b" "$HIGHLIGHT" >&2
	read -rp "==> " var
	printf "%b" "$NC" >&2
	
	OutDeleteRowsAbove	"2"
	StateLine "remove"
	printf "%s" "$var"
}	



UserInputYNQ(){
	local user_input
	
	while true; do
		user_input="$( ReturnUserInput )"
		DebugLog "$user_input"
		case "$user_input" in
			y|ye|yes)
				printf "%s" "y"
				break
			;;
			n|no)
				printf "%s" "n"
				break
			;;
			q|qu|qui|quit)
				printf "%s" "q"
				break
			;;
			*)
			OutLineErr
			OutErr "Ungültige Eingabe"
			sleep 2
			OutDeleteRowsAbove "2"
			;;
		esac 
	done
}

#----------------------------------------------------------------------#

#check string is only once in array
ValidateRedundancyFree() {
    local needle="$1"
    shift
	local item
	
    for item in "$@"; do
        if [[ "$item" == "$needle" ]]; then
			DebugLog "$item : $needle" "ERROR"
            return 1
        fi
    done

}

ValideChoiceIn() {
	local needle="$1"
    shift
	local item
	
    for item in "$@"; do
        if [[ "$item" == "$needle" ]]; then
			DebugLog "$item : $needle" "ERROR"
            return 1
        fi
    done
}

#validates the right characters in scope of options
ValidateChoice(){
	local choice="$1"
	local max="$2"
	
	DebugLog "\$1 choice:$choice \§2 max:$max"
	
	if ! [[ "$choice" =~ ^[1-9][0-9]*$ ]]; then
		DebugLog "choice:$choice  is NOT in range 1 - n" "ERROR"
		return 1
	fi
	
	if ! (( ${#choice} <= ${#max} )); then
		DebugLog "choice$choice has not MORE numbers than $max" "ERROR"
		return 1
	fi
	
	
	if ! (( choice >= 1 && choice <= max )); then
		DebugLog "choice:$choice is less than one or ge than max " "ERROR"
		return 1
	fi
	
}

#returns error code and text if one than more invalid selections

#Displays output
AskUserKeepSelection(){
	local selected=("$@")
	DebugLog "\$@ selected: ${selected[*]}"
	Out ""
	Out "$TXT_USER_ASK"
	Out "${SIG}${selected[@]}${NC}"
	#OutListTwoColumns "${selected[@]}"
	Out "\n"
	Out ""
	Out "${HIGHLIGHT}[y]${NC} $TXT_USER_CHOICE_CONT \t\t \
	${HIGHLIGHT}[q]${NC} $TXT_USER_CHOICE_EXIT"
	Out "${HIGHLIGHT}[n]${NC} $TXT_USER_CHOICE_NEW"
	Out " "
}

#offers choices from array and reasks user


UserInputMultiSelect() { 
    local options=("$@")
    local selected=()
    local choices=()
    local invalid=()
    local choice
    local decision
    local max="${#options[@]}"
	
	DebugLog "options: ${options[*]}"
	while true; do
		ReadUserInput "choices"
		(( ${#choices[@]} > 0 )) || UserInputMultiSelect "${options[@]}" "${LINEO[@]}"
		
		#[[ -n "$choices" ]] || return 1 
		for choice in "${choices[@]}"; do
			ValidateChoice "$choice" "$max" || { invalid+=("$choice"); continue; } 
			ValidateRedundancyFree "${options[$((choice - 1))]}" "${selected[@]}" "selected" || continue
			selected+=("${options[$((choice - 1))]}")
		done
		
		rows=$(( 5 + ${#selected[@]} + 5 ))
		
		if (( ${#invalid} > 0 )); then
			OutDeleteRowsAbove 2
			OutLineErr
			OutErr "${invalid[0]:0:25}"
			sleep 2
			OutDeleteRowsAbove 2
		else
			AskUserKeepSelection "${selected[@]}"
			decision="$( UserInputYNQ )"
			DebugLog "Selected ${selected[@]}" "${LINENO[@]}" 
			case $decision in
			y|ye|yes)
				printf "%s\n" "${selected[@]}"
				break
			;;
			q|qu|qui|quit)
				printf "%s\n" "quit"
				exit 0
			;;
			esac
			OutDeleteRowsAbove "$rows"
		fi
		unset invalid
		unset selected
	done
}



#--------- earlier version --------------------------------------------#
#UserInputMultiSelect() { 
#    local options=("$@")
#    local selected=()
#    local choices=()
#    local invalid=()
#    local choice
#    local decision
#    local max="${#options[@]}"
#	
#	DebugLog "options: ${options[*]}"
#	ReadUserInput "choices"
#	(( ${#choices[@]} > 0 )) || UserInputMultiSelect "${options[@]}"
#	
#	#[[ -n "$choices" ]] || return 1 
#	for choice in "${choices[@]}"; do
#		ValidateChoice "$choice" "$max" || { invalid+=("$choice"); continue; } 
#		ValidateRedundancyFree "${options[$((choice - 1))]}" "${selected[@]}" "selected" || continue
#		selected+=("${options[$((choice - 1))]}")
#	done
#	
#	if (( ${#invalid} > 0 )); then
#		STATE=ERR
#		OutErr "invalid_selections: ${invalid[*]}"
#		StateLine "remove"
#		OutDeleteRowsAbove 1
#		UserInputMultiSelect "${options[@]}"
#	else
#		AskUserKeepSelection "${selected[@]}"
#		decision="$( UserInputYNQ )"
#		rows=$(( 5 + ${#selected[@]} + 2 ))
#		case $decision in
#		y|ye|yes)
#			printf "%s\n" "${selected[@]}"
#			return 0
#		;;
#		q|qu|qui|quit) 
#			printf "%s\n" "quit"
#			exit 0
#		;;
#		esac
#		OutDeleteRowsAbove "$rows"
#		UserInputMultiSelect "${options[@]}"
#	fi
#}



