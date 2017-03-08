# Basic list of files to be generated/converted.
IMAGES_32 = 32/Day 32/Day-Plain 32/Night 32/Night-Plain
IMAGES_43 = 43/Day 43/Day-Plain 43/Night 43/Night-Plain
IMAGES_169 = 169/Day 169/Day-Plain 169/Night 169/Night-Plain
IMAGES_219 = 219/Day 219/Day-Plain 219/Night 219/Night-Plain
IMAGES = ${IMAGES_32} ${IMAGES_43} ${IMAGES_169} ${IMAGES_219}
VARIANTS = Day Day-Plain Night Night-Plain
XMLS = data/core4-plain-timed \
       data/core4-timed \
       data/core4 \
       data/core4-plain \
       data/core4-wallpapers

# Stupid KDE doesn't know how to deal with multi-resolution.
RESO169 = 1366x768 1600x900 1920x1080 2880x1800 1440x900 1280x800
RESO219 = 2560x1080 3440x1440
RESO32 = 1152x768 1280x854 1440x960 2160x1440
RESO43 = 800x600 1024x768 1280x960 1600x1200 2048x1536

# Command definitions.
CD = cd
FIND = find
SED = sed
RM = rm -fv
CP = cp -v
MKDIR = mkdir -pv
LN = ln -svf
PUSHD = pushd
POPD = popd
MV = mv -v
DESTDIR =
DATAROOTDIR = /usr/share

# Version definitions.
CORE = 4.2.1
REL = 4.2
ARCH = x86_64
DATE = 20170308

# Dimension definitions.
H32 = 3000
W32 = 4500
H43 = 3000
W43 = 4000
H169 = 2880
W169 = 5120
H219 = 2880
W219 = 6880

all : png $(XMLS:=.xml) screenshot

$(IMAGES:=-gen.svg) : ${IMAGES:=.svg}
	sed	-e "s|>REL<|>$(REL)<|g" \
		-e "s|ARCHIT|$(ARCH)|g" \
		-e "s|REV|$(REL)|g" \
		-e "s|REL_DATE|$(DATE)|g" \
		-e "s|CORV|$(CORE)|g" \
		"$(subst -gen.svg,.svg,$@)" > "$@"

$(IMAGES_32:=-$(W32)x$(H32).png) : $(IMAGES_32:=-gen.svg)
	inkscape -h $(H32) -w $(W32) -e $@ $(subst -$(W32)x$(H32).png,-gen.svg,$@)

$(IMAGES_43:=-$(W43)x$(H43).png) : $(IMAGES_43:=-gen.svg)
	inkscape -h $(H43) -w $(W43) -e $@ $(subst -$(W43)x$(H43).png,-gen.svg,$@)

$(IMAGES_169:=-$(W169)x$(H169).png) : $(IMAGES_169:=-gen.svg)
	inkscape -h $(H169) -w $(W169) -e $@ $(subst -$(W169)x$(H169).png,-gen.svg,$@)

$(IMAGES_219:=-$(W219)x$(H219).png) : $(IMAGES_219:=-gen.svg)
	inkscape -h $(H219) -w $(W219) -e $@ $(subst -$(W219)x$(H219).png,-gen.svg,$@)

png : $(IMAGES_32:=-$(W32)x$(H32).png) \
      $(IMAGES_43:=-$(W43)x$(H43).png) \
      $(IMAGES_169:=-$(W169)x$(H169).png) \
      $(IMAGES_219:=-$(W219)x$(H219).png)

$(XMLS:=.xml) : ${XMLS:=.xml.in}
	sed	-e "s|@datadir@|$(DATAROOTDIR)|g" \
		-e "s|@COREVER@|$(REL)|g" \
		"$(subst .xml,.xml.in,$@)" > "$@"

$(IMAGES_169:=-screenshot.png) : $(IMAGES:=-gen.svg)
	inkscape -h 250 -w 400 -e $@ $(subst -screenshot.png,-gen.svg,$@)

screenshot : $(IMAGES_169:=-screenshot.png)

clean :
	$(FIND) . -name '*gen*.svg' -exec $(RM) {} \;
	$(FIND) . -name '*.png' -exec $(RM) {} \;
	$(FIND) . -name '*.xml' -exec $(RM) {} \;

install : install-images install-xml install-gnome install-mate install-xfce install-kde

install-images : png
	$(MKDIR) ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core4
	$(CP) $(IMAGES_32:=-$(W32)x$(H32).png) ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core4
	$(CP) $(IMAGES_43:=-$(W43)x$(H43).png) ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core4
	$(CP) $(IMAGES_169:=-$(W169)x$(H169).png) ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core4
	$(CP) $(IMAGES_219:=-$(W219)x$(H219).png) ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core4

install-xml : $(XMLS:=.xml)
	$(MKDIR) ${DESTDIR}/$(DATAROOTDIR)/background-properties
	$(CP) data/core4-plain-timed.xml ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core4
	$(CP) data/core4-timed.xml ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core4
	$(CP) data/core4.xml ${DESTDIR}/$(DATAROOTDIR)/background-properties
	$(CP) data/core4-plain.xml ${DESTDIR}/$(DATAROOTDIR)/background-properties
	$(CP) data/core4-wallpapers.xml ${DESTDIR}/$(DATAROOTDIR)/background-properties

install-gnome : install-xml install-images
	$(MKDIR) ${DESTDIR}/$(DATAROOTDIR)/gnome-background-properties
	$(LN) ../background-properties/core4.xml ${DESTDIR}/$(DATAROOTDIR)/gnome-background-properties
	$(LN) ../background-properties/core4-plain.xml ${DESTDIR}/$(DATAROOTDIR)/gnome-background-properties
	$(LN) ../background-properties/core4-wallpapers.xml ${DESTDIR}/$(DATAROOTDIR)/gnome-background-properties

install-mate : install-xml install-images
	$(MKDIR) ${DESTDIR}/$(DATAROOTDIR)/mate-background-properties
	$(LN) ../background-properties/core4.xml ${DESTDIR}/$(DATAROOTDIR)/mate-background-properties
	$(LN) ../background-properties/core4-plain.xml ${DESTDIR}/$(DATAROOTDIR)/mate-background-properties
	$(LN) ../background-properties/core4-wallpapers.xml ${DESTDIR}/$(DATAROOTDIR)/mate-background-properties

install-xfce : install-images
	$(LN) core4 ${DESTDIR}/$(DATAROOTDIR)/backgrounds/xfce

install-kde : install-images
	for variant in $(VARIANTS); do \
		$(MKDIR) ${DESTDIR}/$(DATAROOTDIR)/wallpapers/$${variant}/contents/images ; \
		$(CP) data/$${variant}.desktop ${DESTDIR}/$(DATAROOTDIR)/wallpapers/$${variant}/metadata.desktop ; \
		$(CP) 169/$${variant}-screenshot.png ${DESTDIR}/$(DATAROOTDIR)/wallpapers/$${variant}/contents/screenshot.png ; \
		$(PUSHD) ${DESTDIR}/$(DATAROOTDIR)/wallpapers/$${variant}/contents/images ; \
		$(LN) ../../../../backgrounds/core4/$${variant}-[0-9]*.png . ; \
		for i in *.png; do \
			$(MV) $${i} $${i##*-} ; \
		done ; \
		for reso169 in $(RESO169); do \
			$(LN) 5120x2880.png $${reso169}.png ; \
		done ; \
		for reso219 in $(RESO219); do \
			$(LN) 6880x2880.png $${reso219}.png ; \
		done ; \
		for reso32 in $(RESO32); do \
			$(LN) 4500x3000.png $${reso32}.png ; \
		done ; \
		for reso43 in $(RESO43); do \
			$(LN) 4000x3000.png $${reso43}.png ; \
		done ; \
		$(POPD) ; \
	done

.PHONY : all clean png \
		install install-image install-xml \
		install-gnome install-mate install-xfce install-kde
