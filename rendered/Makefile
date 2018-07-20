all: campanula-alt.png campanula-wireframe.png campanula.png

campanula-alt.png: campanula-alt.blend
	blender -b campanula-alt.blend -x 0 -o '//campanula-alt_####.png' -f 0 -F PNG -t 0
	mv 'campanula-alt_0000.png' 'campanula-alt.png'

campanula-wireframe.png: campanula-wireframe.blend
	blender -b campanula-wireframe.blend -x 0 -o '//campanula-wireframe_####.png' -f 0 -F PNG -t 0
	mv 'campanula-wireframe_0000.png' 'campanula-wireframe.png'

campanula.png: campanula.blend
	blender -b campanula.blend -x 0 -o "//campanula_####.png" -f 0 -F PNG -t 0
	mv 'campanula_0000.png' 'campanula.png'

clean:
	rm -f *.blend1
