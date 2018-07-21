export OCIO := ./filmic-blender/config.ocio
# This environment variable is required for blender color management to function
ICC = ./icc/profiles/sRGB-elle-V2-g22.icc
NPROC ?= (shell nproc)
VARIANTS = campanula-alt campanula-wireframe campanula

all: 3-2/%-3-2.png 4-3/%-4-3.png 16-10/%-16-10.png 16-9/%-16-9.png 21-9/%-21-9.png

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

3-2/%-3-2.png: all-render
	mkdir -p "3-2"
	for i in $(VARIANTS); do \
		convert-7 $${i}.png -background black -gravity east -extent 5400x3600 -resize 4500x3000 3-2/$${i}-3-2.png;\
	done

4-3/%-4-3.png: all-render
	mkdir -p "4-3"
	for i in $(VARIANTS); do \
		convert-7 $${i}.png -background black -gravity east -extent 4800x3600 -resize 2048x1536 4-3/$${i}-4-3.png;\
	done

16-10/%-16-10.png: all-render
	mkdir -p "16-10"
	for i in $(VARIANTS); do \
		convert-7 $${i}.png -background black -gravity east -extent 5760x3600 -resize 2560x1600 16-10/$${i}-16-10.png;\
	done

16-9/%-16-9.png: all-render
	mkdir -p "16-9"
	for i in $(VARIANTS); do \
		convert-7 $${i}.png -background black -gravity east -extent 6400x3600 -resize 3840x2160 16-9/$${i}-16-9.png;\
	done

21-9/%-21-9.png: all-render
	mkdir -p "21-9"
	for i in $(VARIANTS); do \
		convert-7 $${i}.png -background black -gravity east -extent 8400x3600 -resize 3440x1440 21-9/$${i}-21-9.png;\
	done

clean:
	rm -vf *.blend1
