#!/usr/bin/env python

import argparse
import nibabel
import nilearn.regions
import pandas
import numpy
import os

p = argparse.ArgumentParser()
p.add_argument('--labels_niigz', help='ROI label image', required=True)
p.add_argument('--labels_csv', help='ROI label csv', required=True)
p.add_argument('--data_niigz', help='Time series data to extract', required=True)
p.add_argument('--out_dir', help='Output directory', required=True)
a = p.parse_args()

# nilearn region of interest signal extraction
means,labels = nilearn.regions.img_to_signals_labels(a.data_niigz,a.labels_niigz,strategy='mean')
sdevs,_ = nilearn.regions.img_to_signals_labels(a.data_niigz,a.labels_niigz,strategy='standard_deviation')

# Round the labels we got from the image to nearest int, then match the correct
# region name to each using pandas merge with the separate label csv
label_list = pandas.read_csv(a.labels_csv)
dlabels = pandas.DataFrame([int(x) for x in labels],columns=['Label'])
textlabels = dlabels.merge(label_list,how='left',on='Label')

# Save to file with the region names as column names
means = pandas.DataFrame(means,columns=textlabels.Region)
sdevs = pandas.DataFrame(sdevs,columns=textlabels.Region)

means.to_csv(os.path.join(a.out_dir,'means.csv'),index=False)
sdevs.to_csv(os.path.join(a.out_dir,'sdevs.csv'),index=False)
