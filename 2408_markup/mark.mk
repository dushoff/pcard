io = -stdin -stdout |
define mark
	cat $< | \
	cpdf -add-text "1" -pos-left "20 410" -font-size 15 $(io) \
	cpdf -add-text "2" -pos-left "20 380" -font-size 15 $(io) \
	cpdf -add-text "3" -pos-left "20 350" -font-size 15 $(io) \
	cpdf -add-text "4" -pos-left "20 320" -font-size 15 $(io) \
	cpdf -add-text "5" -pos-left "20 290" -font-size 15 $(io) \
	cpdf -add-text "6" -pos-left "20 260" -font-size 15 $(io) \
	cat > $@
endef
