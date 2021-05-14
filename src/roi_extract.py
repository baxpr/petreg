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

means,labels = nilearn.regions.img_to_signals_labels(a.data_niigz,a.labels_niigz,strategy='mean')
sdevs,_ = nilearn.regions.img_to_signals_labels(a.data_niigz,a.labels_niigz,strategy='standard_deviation')

label_list = pandas.read_csv(a.labels_csv,header=None)
textlabels = label_list[1][label_list[0].searchsorted(labels)]

means = pandas.DataFrame(means,columns=textlabels)
sdevs = pandas.DataFrame(sdevs,columns=textlabels)

means.to_csv(os.path.join(out_dir,'means.csv'),index=False)
sdevs.to_csv(os.path.join(out_dir,'sdevs.csv'),index=False)
