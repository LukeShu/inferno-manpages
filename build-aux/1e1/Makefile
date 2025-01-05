# build-aux/1e1/Makefile - Convert the inferno-1e1 HTML docs to roff manpages
#
# Copyright (C) 2025  Luke T. Shumaker <lukeshu@lukeshu.com>
# SPDX-License-Identifier: MIT

bin_dir := $(patsubst %/,%,$(dir $(firstword $(MAKEFILE_LIST))))
src_dir  = inferno-1e1/html
tmp_dir  = inferno-1e1/tmp
out_dir  = inferno-1e1

src/htmls := $(sort $(wildcard $(src_dir)/*.htm))
src/imgs  := $(sort $(wildcard $(src_dir)/*.gif $(src_dir)/*/*.gif))

# Information about $(src_dir) ##################################################

# $(htmlnames) is the list of values for which we will generate an
# `$(tmp_dir)/{value}.man` file from a correspondingly named
# `{value}.htm` file.
htmlnames = $(filter-out $(htmlnames/deny),$(htmlnames/src)) $(htmlnames/extra)

# values found in $(src_dir)
htmlnames/src = $(patsubst $(src_dir)/%.htm,%,$(src/htmls))

# values to ignore from $(htmlnames/src)
# `$(src_dir)/{value}.htm`.
htmlnames/deny  = mpgs # toc

# extra values that weren't found in $(htmlnames/src)
htmlnames/extra  =

# $(imageurls) is a list of values that we might see <img src="{value}"> for.
imageurls = $(filter-out Next.gif Previous.gif Top.gif,$(patsubst $(src_dir)/%,%,$(src/imgs)))

# Targets #######################################################################

all: copy
.PHONY: all

target/man-htms   = $(foreach x,$(htmlnames),$(tmp_dir)/$x.htm)
target/man-phtmls = $(foreach x,$(htmlnames),$(tmp_dir)/$x.phtml)
target/man-mans   = $(foreach x,$(htmlnames),$(tmp_dir)/$x.man)
target/man-names  = $(foreach x,$(htmlnames),$(tmp_dir)/$x.names)
target/img-phtmls = $(foreach x,$(imageurls),$(tmp_dir)/$x.phtml)

man-htms: $(target/man-htms)
man-phtmls: $(target/man-phtmls)
man-mans: $(target/man-mans)
man-names: $(target/man-names)
img-phtmls: $(target/img-phtmls)
.PHONY: man-htms man-phtmls man-mans man-names img-phtmls

# Configure Make itself #########################################################

.DELETE_ON_ERROR:
.NOTINTERMEDIATE:
.SHELLFLAGS += -eEu -o pipefail

# Create $(tmp_dir) ############################################################

$(tmp_dir) $(tmp_dir)/chars:
	mkdir -p -- $@

# Populate $(tmp_dir): Generate $(htmlnames/extras) ############################

# Populate $(tmp_dir): Copy in other $(htmlnames) ##############################

$(tmp_dir)/%.htm: $(src_dir)/%.htm | $(tmp_dir)
	cp -fT -- $< $@

# Populate $(tmp_dir): Add image-file replacements #############################

$(tmp_dir)/%.phtml: $(bin_dir)/html/%.md | $(tmp_dir)/chars
	<$< pandoc --to=html --wrap=preserve --mathml | sed -E -e 's,</?p>,,g' >$@
$(tmp_dir)/%.phtml: $(bin_dir)/html/%.phtml | $(tmp_dir)/chars
	cp -fT -- $< $@

# Populate $(tmp_dir): Clean/pre-process those HTML files ######################

$(tmp_dir)/%.phtml: $(tmp_dir)/%.htm $(bin_dir)/htmlstrip $(bin_dir)/htmlclean $(bin_dir)/htmlclean.fixlinks.lua $(target/img-phtmls)
	<$< $(bin_dir)/htmlstrip | SELF=$* $(bin_dir)/htmlclean $(tmp_dir) $(imageurls) >$@

# Populate $(tmp_dir): Turn those into manpages ################################

$(tmp_dir)/%.names: $(tmp_dir)/%.phtml $(bin_dir)/html2names $(bin_dir)/html2name
	$(bin_dir)/html2names $< >$@

$(tmp_dir)/%.man: $(tmp_dir)/%.phtml $(tmp_dir)/%.names $(tmp_dir)/%.htm $(bin_dir)/html2man $(bin_dir)/html2man.fixlinks.lua $(target/man-names) $(MAKEFILE_LIST)
	tmp_dir=$(tmp_dir) $(bin_dir)/html2man \
	  $$(<$(tmp_dir)/$*.names sed -En '1s/(.*)\((.*)\)/\1 \2/p') \
	  "$$(<$(filter %.htm,$^) sed -En 's,.*<title>(.*)</title>.*,\1,p' | sed 's/<br>/ /g' | sed -E 's/\s+/ /g')" \
	  <$< \
	  >$@

# Populate $(out_dir): Copy those manpages into place ##########################

copy: $(bin_dir)/copy $(target/man-mans)
	$(bin_dir)/copy $(out_dir) $(filter %.man,$^)
.PHONY: copy
