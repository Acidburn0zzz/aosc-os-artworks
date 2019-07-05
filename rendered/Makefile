export OCIO := ./filmic-blender/config.ocio
# This environment variable is required for blender color management to function
ICC = ./icc/profiles/sRGB-elle-V2-g22.icc
NPROC ?= (shell nproc)
VARIANTS = campanula-alt campanula-wireframe campanula

# Since most DEs expect wallpapers to be sRGB...
CONVERT_COMMON = -background black -gravity east -colorspace sRGB -strip

all: 1-1/%-1-1.png 3-2/%-3-2.png 4-3/%-4-3.png 5-4/%-5-4.png 16-10/%-16-10.png 16-9/%-16-9.png 21-9/%-21-9.png

all-render: $(VARIANTS:=.png)

campanula-alt.png: campanula-alt.blend
	blender -b $^ -x 0 -o '//campanula-alt_####.png' -f 0 -F PNG -t $(NPROC)
	convert +profile '*' campanula-alt_0000.png -profile $(ICC) $@
	rm -v campanula-alt_0000.png

campanula-wireframe.png: campanula-wireframe.blend
	blender -b $^ -x 0 -o '//campanula-wireframe_####.png' -f 0 -F PNG -t $(NPROC)
	convert +profile '*' campanula-wireframe_0000.png -profile $(ICC) $@
	rm -v campanula-wireframe_0000.png

campanula.png: campanula.blend
	blender -b $^ -x 0 -o "//campanula_####.png" -f 0 -F PNG -t $(NPROC)
	convert +profile '*' campanula_0000.png -profile $(ICC) $@
	rm -v campanula_0000.png

1-1/%-1-1.png: all-render
	mkdir -p "1-1"
	for i in $(VARIANTS); do \
		convert $${i}.png $(CONVERT_COMMON) -resize 4096x4096 1-1/$${i}-1-1.png;\
	done

3-2/%-3-2.png: all-render
	mkdir -p "3-2"
	for i in $(VARIANTS); do \
		convert $${i}.png $(CONVERT_COMMON) -extent 5400x3600 -resize 4500x3000 3-2/$${i}-3-2.png;\
	done

4-3/%-4-3.png: all-render
	mkdir -p "4-3"
	for i in $(VARIANTS); do \
		convert $${i}.png $(CONVERT_COMMON) -extent 4800x3600 -resize 2048x1536 4-3/$${i}-4-3.png;\
	done

5-4/%-5-4.png: all-render
	mkdir -p "5-4"
	for i in $(VARIANTS); do \
		convert $${i}.png $(CONVERT_COMMON) -extent 5120x4096 5-4/$${i}-5-4.png;\
	done

16-10/%-16-10.png: all-render
	mkdir -p "16-10"
	for i in $(VARIANTS); do \
		convert $${i}.png $(CONVERT_COMMON) -extent 5760x3600 -resize 2560x1600 16-10/$${i}-16-10.png;\
	done

16-9/%-16-9.png: all-render
	mkdir -p "16-9"
	for i in $(VARIANTS); do \
		convert $${i}.png $(CONVERT_COMMON) -extent 6400x3600 -resize 3840x2160 16-9/$${i}-16-9.png;\
	done

21-9/%-21-9.png: all-render
	mkdir -p "21-9"
	for i in $(VARIANTS); do \
		convert $${i}.png $(CONVERT_COMMON) -extent 8400x3600 -resize 3440x1440 21-9/$${i}-21-9.png;\
	done

clean:
	rm -vf *.blend1
