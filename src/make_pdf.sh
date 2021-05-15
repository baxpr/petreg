#!/usr/bin/env bash

echo "Making PDF"

# Work in output directory
cd ${out_dir}

# Timestamp
thedate=$(date)

# ROI overlaid on mean PET, near PET COM
com=( $(fslstats mrpet_mean_reg -c) )
com[0]=$(echo ${com[0]} + 10 | bc)
fsleyes render -of petroi.png \
	--scene ortho --worldLoc ${com[@]} --displaySpace world \
    --size 1800 600 --xzoom 1000 --yzoom 1000 --zzoom 1000 \
	--layout horizontal --hideCursor \
	mrpet_mean_reg --overlayType volume \
	nseg --overlayType label --outline --outlineWidth 2 --lut random_big

# Same but CT underlay
fsleyes render -of ctroi.png \
	--scene ortho --worldLoc ${com[@]} --displaySpace world \
    --size 1800 600 --xzoom 1000 --yzoom 1000 --zzoom 1000 \
	--layout horizontal --hideCursor \
	mct --overlayType volume \
	nseg --overlayType label --outline --outlineWidth 2 --lut random_big


# Combine
info_string="$project $subject $session $scan"

convert -size 2600x3365 xc:white \
	-gravity center \( petroi.png -geometry '2400x2400+0-0' \) -composite \
	-gravity center -pointsize 48 -annotate +0-1250 \
	"MR ROIs on mean PET" \
	-gravity center \( ctroi.png -geometry '2400x2400+0+1200' \) -composite \
	-gravity center -pointsize 48 -annotate +0-50 \
	"MR ROIs on CT" \
	-gravity SouthEast -pointsize 48 -annotate +100+100 "${thedate}" \
	-gravity NorthWest -pointsize 48 -annotate +100+200 "${info_string}" \
	page1.png

convert page1.png petreg.pdf

