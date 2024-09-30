## This is pcard

current: target
-include target.mk
Ignore = target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

mirrors += out
mirrors += 2407

## 2407.month:
%.month:
	- $(RM) in
	$(LN) $* in

######################################################################

### Check current
current.pdf: $(wildcard in/bmo*.pdf in/BMO*.pdf)
	$(copy)

## Make file list and check accounts
accounts.trim.txt.pdf: in/accounts.txt

## Receipts
files = bill.pdf
files += outbreak.X.receipt.pdf bell.X.receipt.pdf tv.X.receipt.pdf equipment.X.receipt.pdf everywhere.X.receipt.pdf computer.X.receipt.pdf dropbox.X.receipt.pdf
## outbreak.pdf ##
## bell.pdf ##
## tv.pdf ##

## publication.pdf ##
## dropbox.pdf ## dropbox.com/avatar (JD)/settings/billing
## everywhere.pdf ##
## equipment.pdf ##
## computer.pdf ##

## Tag the first page, unless it's too crowded
## The y number is going down from the top: more negative is down
tag.pdf: accounts.txt.pdf current-0.pdf Makefile
	cpdf -stamp-on $< -pos-left "00 -710" $(word 2, $^) -o $@

## Mark receipts with numbers (DELETE extra lines)
## We may need to mark a tagged page or an untagged page
## Sometimes tags go on following page for space
io = -stdin -stdout |
mark.pdf: tag.pdf Makefile
	cat $< | \
	cpdf -add-text "1" -pos-left "20 380" -font-size 15 $(io) \
	cpdf -add-text "2" -pos-left "20 350" -font-size 15 $(io) \
	cpdf -add-text "3" -pos-left "20 320" -font-size 15 $(io) \
	cpdf -add-text "4" -pos-left "20 290" -font-size 15 $(io) \
	cpdf -add-text "5" -pos-left "20 260" -font-size 15 $(io) \
	cpdf -add-text "6" -pos-left "20 230" -font-size 15 $(io) \
	cat > $@

## Make the bill from tagged and marked pages (which may be the same, or different)
bill.pdf: mark.pdf
	pdfjam $^ --outfile $@

dushoff2024XXpcard.pdf: $(files) 
	pdfjam $(filter-out Makefile, $^) --outfile $@

## Copy down-called files
outbreak.pdf: $(wildcard github*.pdf)
	$(copy)

bell.pdf: $(wildcard Bell*.pdf)
	$(copy)

######################################################################

export ms=~/screens/makestuff

Makefile: makestuff/Makefile
makestuff/Makefile:
	ln -s $(ms) .

Sources += accounts.txt
in/accounts.txt: accounts.txt
	$(copy)


######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff

Makefile: makestuff/00.stamp
makestuff/%.stamp: | makestuff
	- $(RM) makestuff/*.stamp
	cd makestuff && $(MAKE) pull
	touch $@
makestuff:
	git clone --depth 1 $(msrepo)/makestuff

-include makestuff/os.mk

## -include makestuff/pipeR.mk
-include makestuff/forms.mk
-include makestuff/receipts.mk
-include makestuff/mirror.mk

-include makestuff/git.mk
-include makestuff/visual.mk
