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
p.add_argument('--out_pfx', help='Output directory and prefix', required=True)
a = p.parse_args()

# Region of interest signal extraction. We need a hack to handle 3D image, since
# nilearn method only works for 4D.
data = nibabel.load(a.data_niigz)
if data.ndim==3:
    means,labels = nilearn.regions.img_to_signals_labels(
        [a.data_niigz,a.data_niigz],a.labels_niigz,strategy='mean')
    sdevs,_ = nilearn.regions.img_to_signals_labels(
        [a.data_niigz,a.data_niigz],a.labels_niigz,strategy='standard_deviation')
    means = means[0,:]
    means = numpy.reshape(means,(1,-1))
    sdevs = sdevs[0,:]
    sdevs = numpy.reshape(sdevs,(1,-1))
else:
    means,labels = nilearn.regions.img_to_signals_labels(
        a.data_niigz,a.labels_niigz,strategy='mean')
    sdevs,_ = nilearn.regions.img_to_signals_labels(
        a.data_niigz,a.labels_niigz,strategy='standard_deviation')

# Round the labels we got from the image to nearest int, then match the correct
# region name to each using pandas merge with the separate label csv
label_list = pandas.read_csv(a.labels_csv)
dlabels = pandas.DataFrame([int(numpy.around(x)) for x in labels],columns=['Label'])
textlabels = dlabels.merge(label_list,how='left',on='Label')

# Save to file with the region names as column names
means = pandas.DataFrame(means,columns=textlabels.Region)
sdevs = pandas.DataFrame(sdevs,columns=textlabels.Region)

means.to_csv(a.out_pfx+'means.csv',index=False)
sdevs.to_csv(a.out_pfx+'sdevs.csv',index=False)
