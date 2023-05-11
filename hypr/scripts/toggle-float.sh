#!/bin/sh

FLOAT=$HOME/.floating

if [ ! -e $FLOAT ]; then
	touch $FLOAT
	hyprctl keyword windowrule float,^(.*)$
else
	rm $FLOAT
	hyprctl keyword windowrule tile,^(.*)$
fi
