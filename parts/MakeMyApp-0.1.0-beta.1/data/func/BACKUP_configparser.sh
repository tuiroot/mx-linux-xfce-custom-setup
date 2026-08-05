scan_profile_dir(){
	local var_name="$1"
	mapfile -t "$var_name" < <(
	find "${BASE_DIR}/data/profiles_lw" -mindepth 1 -maxdepth 1 -type d
)
}

find_config_file(){
	local path="$1"
	local result
	
	mapfile -t result < <(find "$path" -mindepth 1 -maxdepth 1 -type f -name 'makemyapp.conf')
	(( ${#result[@]} == 1 )) || return 1

	printf '%s\n' "${result[0]}"
}

ValidatePackageConfig(){
		local key="$1"
		local value="$2"
		#validate value is not empyt
			if [[ -z "$value" ]]; then
				out_err "Keyvalue is empty ($key)"
				return 1
			fi 
			
			#validate key is known
			case $key in
			APPNAME|ICON|URL|SCOPEADDON)
				return 0
			;;
			*) 
				out_err "Unknown key $key"
				return 1
			;;
			esac
		}


load_config() {
    local file="$1"
    local mode="$2"
    local line key value

    [[ -r "$file" ]] || {
        out_err "Config not readable: $file" >&2
        return 1
    }

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
			
			[[ "$mode" == "package" ]] && ValidatePackageConfig "$key" "$value"
			printf -v $key "%s" "$value" 
       
        else
            out_err "Invalid config line: $line" >&2
            return 1
        fi
    done < "$file"
  }  
  
  
  
	



