#!/usr/bin/env python
#
# Reformat fslmeants output into a more useful format

import argparse
import sys
import pandas

p = argparse.ArgumentParser()
p.add_argument('--out_csv', help='Output csv', required=True)
p.add_argument('--labels_csv', help='Region labels csv', required=True)
p.add_argument('--vals_txt', help='Regional values from fslmeants', required=True)
a = p.parse_args()

# ROI labels from csv file. No header, numbering must match
# the ROI image and fslmeants count. Labels must be unique
rois = pandas.read_csv(a.labels_csv,header=None,names=['Label','Region'])

# Read space-delimited fslmeants text file
data = pandas.read_csv(a.vals_txt,header=None,delimiter='\s+')

# Drop columns of all zero (missing regions)
# https://stackoverflow.com/a/21165116
keeps = (data != 0).any(axis=0)
data = data.loc[:, keeps]
rois = rois.loc[keeps,:]

# Use ROI labels as dataframe column names
data = data.set_axis(rois['Region'],axis=1)

# Save to file
data.to_csv(a.out_csv,index=False)
