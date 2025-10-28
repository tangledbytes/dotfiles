#!/bin/zsh

typeset -A ZSH_LAZY_LOAD_CACHE

function lazysource() {
	local cmd="$1"
	local path="$2"
	
	local loader_fn_name="__lazy_load_${cmd}"

	eval "
	function $loader_fn_name() {
		if [[ -z \"\$ZSH_LAZY_LOAD_CACHE[\"$cmd\"]\" ]]; then
			ZSH_LAZY_LOAD_CACHE[\"$cmd\"]=1
			unalias \"$cmd\"
			source \"$path\"
		fi
		
		# MUST use eval here to force zsh to re-parse the command
		# *after* the unalias and source commands have run.
		# This correctly resolves the new alias or function.
		eval \"$cmd \\\"\\\$@\\\"\"
	}"

	alias "${cmd}=${loader_fn_name}"
}

