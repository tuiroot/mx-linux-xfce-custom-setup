IsItDir(){
	local path="$1"
	path="${path%\*}"
	if [[ ! -d "$path" ]]; then
		DebugLog "Path $path is not a directory" "ERROR"
		return 1
	fi
	}
	
IsItRead() {
	local path="$1"
	path="${path%\*}"
	if [[ ! -r "$path" ]]; then
		DebugLog "Path $path is not readable" "ERROR"
		return 1
	fi
	}
IsItExist() {
	local path="$1"
	path="${path%\*}"
	if [[ ! -e "$path" ]]; then
		DebugLog "$path does not exist" "ERROR"
		return 1
	fi
	}
	
IsItWrite(){
	local path="$1"
	path="${path%\*}"
	if [[ ! -w "$path" ]]; then
		DebugLog "$path is not writeable" "ERROR"
		return 1
	fi
	}

IsItFile(){
	local path="$1"
	path="${path%\*}"
	if [[ ! -f "$path" ]]; then
		DebugLog "$path is not writeable" "ERROR"
		return 1
	fi
	}

IsItInstalled(){
	local programm=$1
	if ! command -v "$programm" > /dev/null ; then
		if [[ -n "$(which "$programm" > /dev/null )" ]]; then
			DebugLog "$programm is not installed" "ERROR"
			return 1
		fi
	fi
}
