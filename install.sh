#!/usr/bin/env bash

fatal(){
	echo "[FATAL] $@"
	exit 1
}

main(){
	local SCRIPT_URL='https://raw.githubusercontent.com/BeerB34r/makemake/refs/heads/main/makemake.sh'
	local UTILS_URL='https://raw.githubusercontent.com/BeerB34r/makemake/refs/heads/main/utils/'
	local THEMES_URL='https://raw.githubusercontent.com/BeerB34r/makemake/refs/heads/main/themes/'
	local -a THEMES=( dune )
	local theme


	which wget 2>/dev/null >/dev/null || fatal "could not find required dependency wget"

	mkdir -p makemake && cd makemake || fatal "failed to create and enter makemake directory"
	mkdir -p utils themes || fatal "failed to create utils and themes directories"
	wget "${SCRIPT_URL}" -O makemake --show-progress -q && chmod +x makemake || fatal "failed to download and set permissions for script"
	wget "${UTILS_URL}functions" --show-progress -q -O utils/functions || fatal "failed to download utils/functions"
	wget "${UTILS_URL}variables" --show-progress -q -O utils/variables || fatal "failed to download utils/variables"
	for theme in ${THEMES[@]}; do
		wget "${THEMES_URL}${theme}" --show-progress -q -O themes/${theme} || fatal "failed to download themes/${theme}"
	done
}
