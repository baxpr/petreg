#!/usr/bin/env bash

# Run pipeline in xvfb
xvfb-run -n $(($$ + 99)) -s '-screen 0 1600x1200x24 -ac +extension GLX'  petreg.sh "$@"
