## This is pcard

current: target
-include target.mk
Ignore = target.mk

vim_session:
	bash -cl "vmt notes.md"

######################################################################

Sources += notes.md

######################################################################

mirrors += out
mirrors += 2407 2408 2409

%_markup:
	$(mkdir)

Sources += $(wildcard *_markup/*.txt *_markup/*.mk)
## 2408.month:
Ignore += in
%.month: % %_markup
	- $(RM) in markup *.pdf
	$(MAKE) $*.get
	$(LN) $* in
	$(LN) $*_markup markup

######################################################################

Ignore += $(wildcard *.pdf)

### Check current
current.pdf: $(wildcard in/bmo*.pdf in/BMO*.pdf)
	$(copy)

## Make file list and check accounts
Sources += accounts.txt
in/accounts.txt: accounts.txt
	$(copy)

Ignore += atrim.txt
atrim.txt: in/accounts.txt
	sed -e "s/##*  *.*//" $< > $@

## Tag the first page, unless it's too crowded 
## The y number is going down from the top: more negative is down
tag.pdf: atrim.txt.pdf current-0.pdf Makefile
	cpdf -stamp-on $< -pos-left "00 -710" $(word 2, $^) -o $@

## Mark receipts with numbers (DELETE extra lines)
## We may need to mark a tagged page or an untagged page
## Sometimes tags go on following page for space
mark.pdf: tag.pdf in/mark.mk
	$(mark)

Sources += mark.mk
in/mark.mk: | mark.mk
	$(pcopy)
-include in/mark.mk

## Make the bill from tagged and marked pages (which may be the same, or different)
## It's been the same for a long time now
bill.pdf: mark.pdf
	pdfjam $^ --outfile $@

## Receipts
## in/bell.pdf
## in/outbreak.pdf
## in/tv.pdf
Sources += receipts.mk
in/receipts.mk: | receipts.mk
	$(pcopy)
-include in/receipts.mk

pcard.pdf: in/receipts.mk $(files)
	pdfjam $(filter-out %.mk, $^) --outfile $@

out/dushoff2024Aug.pdf: pcard.pdf
	$(copy)

######################################################################

## moved from makestuff/receipts.mk

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

Makefile: makestuff/01.stamp
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
