#!/usr/bin/env bash

#----------------------------------------------------------------------#
ConfToDebug(){
	local keys=("$1")
	local values=("$2")
	local i
	
	i=0
	
	DebugLog "$keyvalues" "INFO"
}


load_config() {
    local file="$1"
    local i=0
    local line
    local key
    local value
    local keyvalues
    local -a keys=()
    local -a values=()
    DebugLog "$file" "INFO" "$LINENO"
    
    if [[ -d "$file" ]]; then
		OutErr "$file is a directory"
		return 1
    elif [[ ! -r "$file" ]]; then
        OutErr "Config not readable: $file" >&2
        return 1
    fi

    while IFS= read -r line || [[ -n "$line" ]]; do
        
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
			keyvalues="$keyvalues\n$i\t$key\t\t\t$value}"
        else
			DebugLog "$keyvalues" "ERROR"
            OutErr "Invalid config line: $line" >&2
            return 1
        fi 
    done < "$file"
    
    for key in "${keys[@]}"; do
		printf -v "$key" "%s" "${values[$i]}"
		((i++))
	done
	DebugLog "$keyvalues" "INFO"
    
  }  
  

 LoadOrFallback() {
	local main="$1"
	local fallback="$2"
	
	DebugLog "main:$main; fallback:$fallback"
	
	if ! load_config "$main"; then
		OutErr "Text config could not be load: $main"
		Out "Try fallback: $fallback"
	
		sleep 1
	
		if ! load_config "$fallback"; then                                
			OutErr "Text config could not be load: $fallback"   
			sleep $SLEEPTIME_EXIT  
		exit 1                                             
		fi                                                                      
	fi
}
	



