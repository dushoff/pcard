io = -stdin -stdout |
define mark
	cat $< | \
	cpdf -add-text "1" -pos-left "30 504" -font-size 10 $(io) \
	cpdf -add-text "2" -pos-left "30 492" -font-size 10 $(io) \
	cpdf -add-text "3" -pos-left "30 480" -font-size 10 $(io) \
	cat > $@
endef

define spark
	cpdf -add-text "4" -pos-left "30 468" -font-size 10 $(io) \
	cpdf -add-text "5" -pos-left "30 456" -font-size 10 $(io) \
	cpdf -add-text "6" -pos-left "30 444" -font-size 10 $(io) \
	cat > $@
endef

