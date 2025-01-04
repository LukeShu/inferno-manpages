#!/usr/bin/env bash
# build-aux/download.sh - Download the source data fro the inferno-manpages.git archive
#
# Copyright (C) 2025  Luke T. Shumaker <lukeshu@lukeshu.com>
# SPDX-License-Identifier: MIT

set -euE -o pipefail

rm -rf -- inferno-*

while read -r dir url; do
	git_url="${url%/commit/*}"
	git_dir="cache/${git_url##*/}.git"
	if ! [[ -d "$git_dir" ]]; then
		git clone --bare "$git_url" "$git_dir"
	fi
	if [[ "$url" = */commit/* ]]; then
		git -C "$git_dir" worktree add "$PWD/cache/tmp" "${url#*/commit/}"
	else
		git -C "$git_dir" worktree add "$PWD/cache/tmp"
	fi
	cp -aT -- cache/tmp/man "$dir"
	rm -rf -- cache/tmp
	git -C "$git_dir" worktree prune
done < <(<README.md sed -En 's,^\|.*\[\./(inferno-[^/]*)/\]\([^)]*\) *\| \[[^]]*\]\((https://github.com/\S*)\) *\|$,\1 \2,p')
