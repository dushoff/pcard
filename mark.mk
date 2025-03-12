io = -stdin -stdout |
define mark
	cat $< | \
	cpdf -add-text "1" -pos-left "20 390" -font-size 15 $(io) \
	cpdf -add-text "2" -pos-left "20 360" -font-size 15 $(io) \
	cpdf -add-text "3" -pos-left "20 330" -font-size 15 $(io) \
	cpdf -add-text "4" -pos-left "20 300" -font-size 15 $(io) \
	cpdf -add-text "5" -pos-left "20 270" -font-size 15 $(io) \
	cpdf -add-text "6" -pos-left "20 240" -font-size 15 $(io) \
	cat > $@
endef
