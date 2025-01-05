# Makefile - Main entrypoint to generate the inferno-manpages archive
#
# Copyright (C) 2025  Luke T. Shumaker <lukeshu@lukeshu.com>
# SPDX-License-Identifier: MIT

all:
	./build-aux/download
	$(MAKE) -f build-aux/1e0/Makefile
	$(MAKE) -f build-aux/1e1/Makefile
.PHONY: all
