#!/bin/bash

# FZF functionality:
export FZF_DEFAULT_COMMAND="fdfind --hidden --color=never"

local _dirs=(~/.config/zsh ~/.config/kitty ~/.config/micro)

function pfzf() {
	fzf -m --preview-window=wrap --keep-right --preview 'batcat --style=numbers --color=always {}' $@
}

function qfzf() {
	if [[ "$1" == "." ]]; then
		pfzf
		return
	fi

	echo $(tree -aifFU --noreport ${_dirs[@]} | pfzf $@)
}

function qfzf_files() {
	if [[ ("$1" == ".") && ("$2" == "-a") ]]; then
		fd --no-ignore --hidden --type=file | pfzf
		return
	elif [[ "$1" == "." ]]; then
		fd --type=file | pfzf
		return
	fi

	echo $(tree -aifFU --noreport ${_dirs[@]} | grep -v -E '/$' | pfzf $@)
}

function qfzf_dirs() {
	if [[ ("$1" == ".") && ("$2" == "-a") ]]; then
		fd --no-ignore --hidden --type=directory | fzf -m
		return
	elif [[ "$1" == "." ]]; then
		fd --type=directory | fzf -m
		return
	fi

	fd --no-ignore --hidden --type=directory . ~ | fzf -m $@
}

function qcd() {
	local tmp=$(qfzf_dirs $@)
	if [[ -n $tmp ]]; then
		cd $tmp
	fi
}

function qrealpath() {
	local tmp=$(qfzf_files $@)
	if [[ -n $tmp ]]; then
		realpath $tmp
	fi
}

function qcat() {
	local tmp=$(qfzf_files $@)
	if [[ -n $tmp ]]; then
		cat $tmp
	fi
}

function qbat() {
	local tmp=$(qfzf_files $@)
	if [[ -n $tmp ]]; then
		bat --paging=never $tmp
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
	history 1 | fzf +s --tac | awk '{$1=""; print $0}' | trim | setclip
}

function qdiff() {
	local preview="git diff ${@:-HEAD} --color=always -- {-1}"
	git diff ${@:-HEAD} --name-only | fzf -m --ansi --keep-right --preview-window="wrap" --preview $preview
}

function qnotes () {
	local preview='batcat --style=numbers --color=always {}'
	local tmp=$(fd --type=file . ~/notes | fzf -m --keep-right --preview-window="wrap" --preview $preview)
	if [[ -n $tmp ]]; then
		cat $tmp
	fi
}
