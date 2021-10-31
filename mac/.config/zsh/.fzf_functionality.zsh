#!/bin/bash

# FZF functionality:
export FZF_DEFAULT_COMMAND="fd --hidden --color=never"

local _dirs=(~/.config ~/.docker ~/.kube ~/.ssh ~/.vdp /bin ~/Downloads ~/notes ~/repos)
local _tree_cache=""

function __qupdate_cache() {
	_tree_cache=$(tree -aifFU --noreport ${_dirs[@]})
}

function __check_cache() {
    [ -z "$_tree_cache" ] && __qupdate_cache
}

function pfzf() {
	fzf -m --preview-window=wrap --keep-right --preview 'bat --style=numbers --color=always {}' $@
}

function qfzf() {
	if [[ "$1" == "." ]]; then
		pfzf
		return
	fi

    __check_cache
	echo $(echo $_tree_cache | pfzf $@)
}

function qfzf_files() {

	if [[ ("$1" == ".") && ("$2" == "-a") ]]; then
		fd --no-ignore --hidden --type=file | pfzf
		return
	elif [[ "$1" == "." ]]; then
		fd --type=file | pfzf
		return
	fi

	__check_cache
	echo $(echo $_tree_cache | grep -v -E '/$' | pfzf $@)
}

function qfzf_dirs() {

	if [[ ("$1" == ".") && ("$2" == "-a") ]]; then
		fd --no-ignore --hidden --type=directory | fzf -m
		return
	elif [[  "$1" == "." ]]; then
		fd --type=directory | fzf -m
		return
	fi

	fd --no-ignore --hidden --type=directory -E Library -E Pictures . ~ | fzf -m $@
}

function qcd() {
	local tmp=$(qfzf_dirs $@)
	if [[ -n $tmp ]]; then
		cd $tmp
	fi
}

function qcat() {
	local tmp=$(qfzf_files $@)
  	if [[ -n $tmp ]]; then
		cat $(echo $tmp | tr '\n' ' ')
  	fi
}

function qrealpath() {
	local tmp=$(qfzf_files $@)
	if [[ -n $tmp ]]; then
		realpath $tmp
	fi
}

function qbat() {
	local tmp=$(qfzf_files $@)
  	if [[ -n $tmp ]]; then
		bat --paging=never $(echo $tmp | tr '\n' ' ')
 	fi
}

function qnano() {
	local tmp=$(qfzf_files $@)
	if [[ -n $tmp ]]; then
		nano $tmp
	fi
}

function qmicro() {
	local tmp=$(qfzf_files $@)
	if [[ -n $tmp ]]; then
		micro $tmp
	fi
}

function qcode() {
	local tmp=$(qfzf $@)
	if [[ -n $tmp ]]; then
		code $tmp
 	fi
}

function qhistory() {
	history | tail -r | fzf | awk '{$1=""; print $0}' | trim | setclip
}

function qdiff() {
	local preview="git diff ${@:-HEAD} --color=always -- {-1}"
	git diff ${@:-HEAD} --name-only | fzf -m --ansi --keep-right --preview-window="wrap" --preview $preview
}

function qnotes() {
	local tmp=$(tree -ifF --noreport ~/notes -I images)
	tmp=$(echo $tmp | tail -n +2) 									# remove the first line which is the root diretory.
	tmp=$(echo $tmp | awk 'NR==1{print "add new"}1')				# add a noption for new note.
	tmp=$(echo $tmp | fzf --preview-window=wrap --preview 'cat {}')	# fzf with wrapping preview.

	if [[ -z $tmp ]]; then
		return
	fi

	if [[ "$tmp" == "add new" ]]; then
		local name=""
		echo "Enter note name:"
		read name
		micro ~/notes/$name
	else
		cat $tmp
	fi
}

function qssh() {
	local host=$(cat ~/.ssh/known_hosts | awk '{print $1}' | tr "," " " | fzf | awk '{print $1}')
	if [[ -z $host ]]; then
		return
	fi

	echo ssh $host $@
	if [[ "$host" != "" ]]; then
		ssh $host $@
	fi
}
