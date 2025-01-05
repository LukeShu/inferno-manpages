# build-aux/1e0/Makefile - Convert the inferno-1e0 HTML docs to roff manpages
#
# Copyright (C) 2025  Luke T. Shumaker <lukeshu@lukeshu.com>
# SPDX-License-Identifier: MIT

bin_dir := $(patsubst %/,%,$(dir $(firstword $(MAKEFILE_LIST))))
src_dir  = inferno-1e0/html
tmp_dir  = inferno-1e0/tmp
out_dir  = inferno-1e0

src/htmls := $(sort $(wildcard $(src_dir)/*.htm))
src/imgs  := $(sort $(wildcard $(src_dir)/*.gif $(src_dir)/*/*.gif))

# Information about $(src_dir) ##################################################

# $(htmlnames) is the list of values for which we will generate an
# `$(tmp_dir)/{value}.man` file from a correspondingly named
# `{value}.htm` file.
htmlnames = $(filter-out $(htmlnames/deny),$(htmlnames/src)) $(htmlnames/extra)

# values found in $(src_dir)
htmlnames/src = $(patsubst $(src_dir)/%.htm,%,$(src/htmls))

# NB: ./htmlclean contains a "duplicate" of this list.
                            # There is no chapter 1.
htmlnames/intros  = devices # chapter 2
htmlnames/intros += proto   # chapter 3
htmlnames/intros += cmd_env # chapter 4
htmlnames/intros += cmd     # chapter 5
htmlnames/intros += daemons # chapter 6
htmlnames/intros += md      # chapter 7, also i_modu.htm
htmlnames/intros += md_sys  # chapter 8
htmlnames/intros += md_sec  # chapter 9
                            # There is no chapter 10.
htmlnames/intros += md_draw # chapter 11
htmlnames/intros += md_pref # chapter 12
htmlnames/intros += md_tk   # chapter 13
htmlnames/intros += md_math # chapter 14
htmlnames/intros += md_misc # chapter 15
htmlnames/intros += formats # chapter A

# values to ignore from $(htmlnames/src)
# `$(src_dir)/{value}.htm`.
htmlnames/deny  = index html1 tm01fr10             # toc/indexes
htmlnames/deny += proto10 proto11                  # blank pages
htmlnames/deny += i_modu%                          # inputs to md-0intro
htmlnames/deny += md_sec1 md_sec2 md_sec3 md_sec22 # inputs to md_sec-0intro
htmlnames/deny += md_tk1                           # inputs to md_tk-0intro
htmlnames/deny += $(htmlnames/intros)              # we'll make -0intro variants of these

# extra values that weren't found in $(htmlnames/src)
htmlnames/extra  = $(addsuffix -0intro,$(htmlnames/intros))

# $(imageurls) is a list of values that we might see <img src="{value}"> for.
imageurls = $(filter-out Next.gif Previous.gif Top.gif,$(patsubst $(src_dir)/%,%,$(src/imgs)))

# Targets #######################################################################

all: copy
.PHONY: all

target/man-htms   = $(foreach x,$(htmlnames),$(tmp_dir)/$x.htm)
target/man-phtmls = $(foreach x,$(htmlnames),$(tmp_dir)/$x.phtml)
target/man-mans   = $(foreach x,$(htmlnames),$(tmp_dir)/$x.man)
target/img-phtmls = $(foreach x,$(imageurls),$(tmp_dir)/$x.phtml)

man-htms: $(target/man-htms)
man-phtmls: $(target/man-phtmls)
man-mans: $(target/man-mans)
img-phtmls: $(target/img-phtmls)
.PHONY: man-htms man-phtmls man-mans img-phtmls

# Configure Make itself #########################################################

.DELETE_ON_ERROR:
.NOTINTERMEDIATE:
.SHELLFLAGS += -eEu -o pipefail

# Create $(tmp_dir) ############################################################

$(tmp_dir) $(tmp_dir)/chars:
	mkdir -p -- $@

# Populate $(tmp_dir): Generate $(htmlnames/extras) ############################

$(tmp_dir)/devices-0intro.htm \
$(tmp_dir)/proto-0intro.htm \
$(tmp_dir)/cmd_env-0intro.htm \
$(tmp_dir)/cmd-0intro.htm \
$(tmp_dir)/daemons-0intro.htm \
$(tmp_dir)/md_sys-0intro.htm \
$(tmp_dir)/md_draw-0intro.htm \
$(tmp_dir)/md_pref-0intro.htm \
$(tmp_dir)/md_math-0intro.htm \
$(tmp_dir)/md_misc-0intro.htm \
$(tmp_dir)/formats-0intro.htm \
: $(tmp_dir)/%-0intro.htm: $(src_dir)/%.htm | $(tmp_dir)
	cp -fT -- $< $@

$(tmp_dir)/md-0intro.htm: $(src_dir)/i_modu.htm
$(tmp_dir)/md-0intro.htm: $(src_dir)/i_modu8.htm
$(tmp_dir)/md-0intro.htm: $(MAKEFILE_LIST) | $(tmp_dir)
	{ \
	  <$(src_dir)/i_modu.htm  sed -e 's/The modules are as follows://' -e '/<ul>/Q'; \
	  <$(src_dir)/i_modu8.htm sed -n -e '/^<\/a>/,$$p'; \
	} > $@

$(tmp_dir)/md_sec-0intro.htm: $(src_dir)/md_sec.htm
$(tmp_dir)/md_sec-0intro.htm: $(src_dir)/md_sec1.htm
$(tmp_dir)/md_sec-0intro.htm: $(src_dir)/md_sec2.htm
$(tmp_dir)/md_sec-0intro.htm: $(src_dir)/md_sec3.htm
$(tmp_dir)/md_sec-0intro.htm: $(src_dir)/md_sec22.htm
$(tmp_dir)/md_sec-0intro.htm: $(bin_dir)/htmlstrip $(bin_dir)/htmldemote
$(tmp_dir)/md_sec-0intro.htm: $(MAKEFILE_LIST) | $(tmp_dir)
	{ \
	  <$(src_dir)/md_sec.htm   sed -e '/<hr><\/a><a name="854868">/Q'; \
	  <$(src_dir)/md_sec1.htm  $(bin_dir)/htmlstrip   | $(bin_dir)/htmldemote; \
	  <$(src_dir)/md_sec2.htm  $(bin_dir)/htmlstrip   | $(bin_dir)/htmldemote; \
	  <$(src_dir)/md_sec3.htm  $(bin_dir)/htmlstrip   | $(bin_dir)/htmldemote; \
	  <$(src_dir)/md_sec22.htm sed -e '1,/<hr><br>/d' | $(bin_dir)/htmldemote; \
	} >$@

$(tmp_dir)/md_tk-0intro.htm: $(src_dir)/md_tk.htm
$(tmp_dir)/md_tk-0intro.htm: $(src_dir)/md_tk1.htm
$(tmp_dir)/md_tk-0intro.htm: $(bin_dir)/htmldemote
$(tmp_dir)/md_tk-0intro.htm: $(MAKEFILE_LIST) | $(tmp_dir)
	{ \
	  <$(src_dir)/md_tk.htm  sed -e '/<a name="md_tk1">/Q'; \
	  <$(src_dir)/md_tk1.htm sed -e '1,/<hr><br>/d' | $(bin_dir)/htmldemote; \
	} >$@

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

$(tmp_dir)/%.names: $(tmp_dir)/%.phtml $(bin_dir)/html2names
	$(bin_dir)/html2names $< >$@

$(tmp_dir)/%.man: $(tmp_dir)/%.phtml $(tmp_dir)/%.names $(tmp_dir)/%.htm $(bin_dir)/html2man $(MAKEFILE_LIST)
	$(bin_dir)/html2man \
	  $$(<$(filter %.names,$^) sed -En '1s/(.*)\((.*)\)/\1 \2/p') \
	  "$$(<$(filter %.htm,$^) sed -En 's,.*<title>(.*)</title>.*,\1,p' | sed 's/<br>/ /g' | sed -E 's/\s+/ /g')" \
	  <$< \
	  >$@

# Populate $(out_dir): Copy those manpages into place ##########################

copy: $(bin_dir)/copy $(target/man-mans)
	$(bin_dir)/copy $(out_dir) $(filter %.man,$^)
.PHONY: copy
