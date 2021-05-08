#!/usr/bin/env python

import sys
import pandas

labels_txt = sys.argv[1]
vals_txt = sys.argv[2]

rois = pandas.read_csv(labels_txt,header=None)
print(rois)
print(rois.loc[:,0].values)
data = pandas.read_csv(vals_txt,header=None,delimiter='\s+')

print(data)
