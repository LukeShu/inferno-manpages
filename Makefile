# Makefile - Main entrypoint to generate the inferno-manpages archive
#
# Copyright (C) 2025  Luke T. Shumaker <lukeshu@lukeshu.com>
# SPDX-License-Identifier: MIT

all:
	./build-aux/download.sh
	$(MAKE) -f build-aux/1e0/Makefile
.PHONY: all
