#!/usr/bin/env python

import argparse
import pandas
import numpy
import os

p = argparse.ArgumentParser()
p.add_argument('--roivals_csv', help='Extracted ROI vals that include cerebellum', required=True)
a = p.parse_args()

rois = pandas.read_csv(a.roivals_csv)
cerval = rois['Cerebellum']

if len(cerval) != 1:
    raise Exception(f'Need 1 value, got {len(cerval)}')

print(cerval)
