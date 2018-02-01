# Basic list of files to be generated/converted.
IMAGES_32 = 32/A 32/B 32/Plain
IMAGES_43 = 43/A 43/B 43/Plain
IMAGES_54 = 54/A 54/B 54/Plain
IMAGES_169 = 169/A 169/B 169/Plain
IMAGES_1610 = 1610/A 1610/B 1610/Plain
IMAGES_219 = 219/A 219/B 219/Plain
IMAGES = ${IMAGES_32} ${IMAGES_43} ${IMAGES_54} ${IMAGES_169} ${IMAGES_1610} ${IMAGES_219}
VARIANTS = A B Plain
XMLS = data/core5-a \
       data/core5-b \
       data/core5-plain \
       data/core5-rendered \
       data/core5-a-wallpapers \
       data/core5-b-wallpapers \
       data/core5-plain-wallpapers \
       data/core5-rendered-wallpapers

# Stupid KDE doesn't know how to deal with multi-resolution.
RESO11 = 4096x4096 2048x2048
RESO169 = 1366x768 1600x900 1920x1080 2880x1800 3840x2160
RESO1610 = 1280x800 1440x900 1680×1050 1920×1200 2560×1600
RESO219 = 2560x1080 3440x1440
RESO32 = 1152x768 1280x854 1440x960 2160x1440
RESO43 = 800x600 1024x768 1280x960 1600x1200 2048x1536
RESO54 = 1280x1024 2560x2048 5120x4096

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

# Dimension definitions.
H32 = 3000
W32 = 4500
H43 = 3000
W43 = 4000
H54 = 3600
W54 = 4500
H169 = 2880
W169 = 5120
H1610 = 3200
W1610 = 5120
H219 = 2880
W219 = 6880

all : png $(XMLS:=.xml) $(XMLSW:=.xml) screenshot

$(IMAGES_32:=-$(W32)x$(H32).png) : $(IMAGES_32:=.svg)
	inkscape -h $(H32) -w $(W32) -e $@ $(subst -$(W32)x$(H32).png,.svg,$@)

$(IMAGES_43:=-$(W43)x$(H43).png) : $(IMAGES_43:=.svg)
	inkscape -h $(H43) -w $(W43) -e $@ $(subst -$(W43)x$(H43).png,.svg,$@)

$(IMAGES_54:=-$(W54)x$(H54).png) : $(IMAGES_54:=.svg)
	inkscape -h $(H54) -w $(W54) -e $@ $(subst -$(W54)x$(H54).png,.svg,$@)

$(IMAGES_169:=-$(W169)x$(H169).png) : $(IMAGES_169:=.svg)
	inkscape -h $(H169) -w $(W169) -e $@ $(subst -$(W169)x$(H169).png,.svg,$@)

$(IMAGES_1610:=-$(W1610)x$(H1610).png) : $(IMAGES_1610:=.svg)
	inkscape -h $(H1610) -w $(W1610) -e $@ $(subst -$(W1610)x$(H1610).png,.svg,$@)

$(IMAGES_219:=-$(W219)x$(H219).png) : $(IMAGES_219:=.svg)
	inkscape -h $(H219) -w $(W219) -e $@ $(subst -$(W219)x$(H219).png,.svg,$@)

png : $(IMAGES_32:=-$(W32)x$(H32).png) \
      $(IMAGES_43:=-$(W43)x$(H43).png) \
      $(IMAGES_54:=-$(W54)x$(H54).png) \
      $(IMAGES_169:=-$(W169)x$(H169).png) \
      $(IMAGES_1610:=-$(W1610)x$(H1610).png) \
      $(IMAGES_219:=-$(W219)x$(H219).png)

$(XMLS:=.xml) : ${XMLS:=.xml.in}
	sed	-e "s|@datadir@|$(DATAROOTDIR)|g" \
		"$(subst .xml,.xml.in,$@)" > "$@"

$(IMAGES_169:=-screenshot.png) : $(IMAGES:=.svg)
	inkscape -h 250 -w 400 -e $@ $(subst -screenshot.png,.svg,$@)

screenshot : $(IMAGES_169:=-screenshot.png)

clean :
	$(FIND) . -name '*gen*.svg' -exec $(RM) {} \;
	for image in "32 43 54 169 1610 219"; do \
		$(FIND) $${image} -name '*.png' -exec $(RM) {} \; ;\
	done
	$(FIND) . -name '*.xml' -exec $(RM) {} \;

install : install-images install-xml install-gnome install-mate install-xfce install-kde

install-images : png
	$(MKDIR) ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core5
	$(CP) rendered/*.jpg ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core5
	$(CP) $(IMAGES_32:=-$(W32)x$(H32).png) ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core5
	$(CP) $(IMAGES_43:=-$(W43)x$(H43).png) ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core5
	$(CP) $(IMAGES_54:=-$(W54)x$(H54).png) ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core5
	$(CP) $(IMAGES_169:=-$(W169)x$(H169).png) ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core5
	$(CP) $(IMAGES_1610:=-$(W1610)x$(H1610).png) ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core5
	$(CP) $(IMAGES_219:=-$(W219)x$(H219).png) ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core5

install-xml : $(XMLS:=.xml)
	$(MKDIR) ${DESTDIR}/$(DATAROOTDIR)/background-properties
	$(MKDIR) ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core5
	$(CP) data/core5-a.xml ${DESTDIR}/$(DATAROOTDIR)/background-properties
	$(CP) data/core5-b.xml ${DESTDIR}/$(DATAROOTDIR)/background-properties
	$(CP) data/core5-plain.xml ${DESTDIR}/$(DATAROOTDIR)/background-properties
	$(CP) data/core5-rendered.xml ${DESTDIR}/$(DATAROOTDIR)/background-properties
	$(CP) data/core5-a-wallpapers.xml ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core5
	$(CP) data/core5-b-wallpapers.xml ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core5
	$(CP) data/core5-plain-wallpapers.xml ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core5
	$(CP) data/core5-rendered-wallpapers.xml ${DESTDIR}/$(DATAROOTDIR)/backgrounds/core5

install-gnome : install-xml install-images
	$(MKDIR) ${DESTDIR}/$(DATAROOTDIR)/gnome-background-properties
	$(LN) ../background-properties/core5-a.xml ${DESTDIR}/$(DATAROOTDIR)/gnome-background-properties
	$(LN) ../background-properties/core5-b.xml ${DESTDIR}/$(DATAROOTDIR)/gnome-background-properties
	$(LN) ../background-properties/core5-plain.xml ${DESTDIR}/$(DATAROOTDIR)/gnome-background-properties
	$(LN) ../background-properties/core5-rendered.xml ${DESTDIR}/$(DATAROOTDIR)/gnome-background-properties

install-mate : install-xml install-images
	$(MKDIR) ${DESTDIR}/$(DATAROOTDIR)/mate-background-properties
	$(LN) ../background-properties/core5-a.xml ${DESTDIR}/$(DATAROOTDIR)/mate-background-properties
	$(LN) ../background-properties/core5-b.xml ${DESTDIR}/$(DATAROOTDIR)/mate-background-properties
	$(LN) ../background-properties/core5-plain.xml ${DESTDIR}/$(DATAROOTDIR)/mate-background-properties
	$(LN) ../background-properties/core5-rendered.xml ${DESTDIR}/$(DATAROOTDIR)/mate-background-properties

install-xfce : install-images
	$(MKDIR) ${DESTDIR}$(DATAROOTDIR)/backgrounds/xfce; \
	$(PUSHD) ${DESTDIR}$(DATAROOTDIR)/backgrounds/xfce; \
	$(LN) ../core5/*.png .; \
	$(LN) ../core5/*.jpg .; \
	$(POPD)

install-kde : install-images
	for variant in $(VARIANTS); do \
		$(MKDIR) ${DESTDIR}/$(DATAROOTDIR)/wallpapers/$${variant}/contents/images ; \
		$(CP) data/$${variant}.desktop ${DESTDIR}/$(DATAROOTDIR)/wallpapers/$${variant}/metadata.desktop ; \
		$(CP) 169/$${variant}-screenshot.png ${DESTDIR}/$(DATAROOTDIR)/wallpapers/$${variant}/contents/screenshot.png ; \
		$(PUSHD) ${DESTDIR}/$(DATAROOTDIR)/wallpapers/$${variant}/contents/images ; \
		$(LN) ../../../../backgrounds/core5/$${variant}-[0-9]*.png . ; \
		for i in *.png; do \
			$(MV) $${i} $${i##*-} ; \
		done ; \
		for reso169 in $(RESO169); do \
			$(LN) 5120x2880.png $${reso169}.png ; \
		done ; \
		for reso1610 in ${RESO1610}; do \
			$(LN) 5120x3200.png $${reso1610}.png ; \
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
		for reso54 in ${RESO54}; do \
			$(LN) 4500x3600.png $${reso54}.png ; \
		done ; \
		$(POPD) ; \
	done

.PHONY : all clean png \
		install install-image install-xml \
		install-gnome install-mate install-xfce install-kde
