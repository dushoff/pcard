## This is pcard

current: target
-include target.mk
Ignore = target.mk

vim_session:
	bash -ic "vmt notes.md todo.md flow.md"

######################################################################

Sources += notes.md todo.md flow.md

######################################################################

mirrors += out cloud
tmirrors += 2604
oldmirrors += 2601 2602 2603
oldmirrors += 2508 2509 2510
oldmirrors += 2511 2512 2503/ 2504/
mirrors += $(tmirrors)

## Old stuff is living _only_ in the cloud (and the history) for now, witg?
archive_all: $(oldmirrors:%=%.archive)
%.archive: 
	rm -fr $*/ $*.*

######################################################################

## Make stuff from here using current/in etc (don't need to svs)

Makefile: 2604.month
Ignore += in
Ignore += *.month
%.month: %
	- $(RM) in *.pdf
	$(LN) $* in
	touch $@

######################################################################

Ignore += $(wildcard *.pdf)

######################################################################

### CHECK 
current.pdf: $(wildcard in/Card*.PDF in/bmo*.pdf in/BMO*.pdf)
	$(copy)

######################################################################

### TAG
## tag.pdf: in/accounts.txt
tag.pdf: atrim.txt.pdf current-0.pdf Makefile
	cpdf -stamp-on $< -pos-left "0 -410" $(word 2, $^) -o $@

## Make file list and check accounts
## Add account numbers (tags) to the first page
## Or sometimes do something else, but I no longer remember what
## The y number is going down from the top: more negative is down
Sources += accounts.txt
in/accounts.txt: accounts.txt
	$(copy)

Ignore += atrim.txt
atrim.txt: in/accounts.txt
	sed -e "s/##*  *.*//" $< > $@

######################################################################

## MARK

## bill.pdf: in/mark.mk

## Mark receipts with numbers (DELETE extra lines)
## We may need to mark a tagged page or an untagged page
## Sometimes tags go on following page for space
## mark location moved for the first time in years 2025 Mar 10 (Mon)
## ... and now it moves a bit </grumble>
mark.pdf: tag.pdf in/mark.mk
	$(mark)

Sources += mark.mk
in/mark.mk: | mark.mk
	$(pcopy)
-include in/mark.mk

## Make the bill from tagged and marked pages (which may be the same, or different)
## It's been the same for a long time now
bill.pdf: mark.pdf | in/mark.mk
	pdfjam $^ --outfile $@

######################################################################

## Receipts

## pcard.pdf: in/receipts.mk bill.pdf

## in/bell.pdf
## in/outbreak.pdf

## in/equip.pdf
## in/meeting.pdf
## in/late.pdf

## Wondering if these included files should be PRECIOUS? Are they dropped?
## Needed to delete two empty .mk files today. WHYY?
## Why is LN not working here?
in/receipts.mk: | receipts.mk
	$(pcopy)
-include in/receipts.mk

pcard.pdf: in/receipts.mk $(files)
	pdfjam $(filter-out %.mk, $^) --outfile $@

## downcall in/ ## , or copy directly to the target
in/outbreak.pdf:
	$(CP) in/github*.pdf $@
in/bell.pdf:
	$(CP) in/Bell*.pdf $@

## mv in/register.pdf ~/Downloads ##
Sources += receipts.mk

######################################################################

## CHANGE date and submit

## Jan submitted to Michelle
out/dushoff2026Apr.pdf: pcard.pdf
	$(copy)

######################################################################

## moved from makestuff/receipts.mk; but also still there apparently

%.1.receipt.pdf: page=1
%.2.receipt.pdf: page=2
%.3.receipt.pdf: page=3
%.4.receipt.pdf: page=4
%.5.receipt.pdf: page=5
%.6.receipt.pdf: page=6
%.7.receipt.pdf: page=7
%.8.receipt.pdf: page=8
%.1.receipt.pdf %.2.receipt.pdf %.3.receipt.pdf %.4.receipt.pdf %.5.receipt.pdf %.6.receipt.pdf %.7.receipt.pdf %.8.receipt.pdf: in/%.pdf
	cpdf -add-text "$(page)" -topright 30 -font-size 24 $< -o $@

%.png.pdf: %.png
	$(convert)

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff

Makefile: makestuff/02.stamp
makestuff/%.stamp: | makestuff
	- $(RM) makestuff/*.stamp
	cd makestuff && $(MAKE) pull
	touch $@
makestuff:
	git clone --depth 1 $(msrepo)/makestuff

-include makestuff/os.mk

-include makestuff/forms.mk
-include makestuff/mirror.mk

-include makestuff/git.mk
-include makestuff/visual.mk
