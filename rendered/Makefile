export OCIO := ./filmic-blender/config.ocio
# This environment variable is required for blender color management to function
ICC = ./icc/profiles/sRGB-elle-V2-g22.icc
NPROC ?= (shell nproc)

all: campanula-alt.png campanula-wireframe.png campanula.png

campanula-alt_0000.png: campanula-alt.blend
	blender -b $^ -x 0 -o '//campanula-alt_####.png' -f 0 -F PNG -t $(NPROC)

campanula-alt.png: campanula-alt_0000.png
	convert +profile '*' $^ -profile $(ICC) $@

campanula-wireframe_0000.png: campanula-wireframe.blend
	blender -b $^ -x 0 -o '//campanula-wireframe_####.png' -f 0 -F PNG -t $(NPROC)

campanula-wireframe.png: campanula-wireframe_0000.png
	convert +profile '*' $^ -profile $(ICC) $@

campanula_0000.png: campanula.blend
	blender -b $^ -x 0 -o "//campanula_####.png" -f 0 -F PNG -t $(NPROC)

campanula.png: campanula_0000.png
	convert +profile '*' $^ -profile $(ICC) $@

clean:
	rm -vf *.blend1
	rm -vf *_0000.png
