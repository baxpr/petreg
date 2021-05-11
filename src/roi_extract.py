#!/usr/bin/env python

import argparse
import nibabel
import nilearn.regions
import pandas

p = argparse.ArgumentParser()
p.add_argument('--labels_niigz', help='ROI label image', required=True)
p.add_argument('--labels_csv', help='ROI label csv', required=False)
p.add_argument('--data_niigz', help='Time series data to extract', required=True)
a = p.parse_args()

# FLIRT is resampling with not quiiiiite identical affines (error 1.5e-8). Try -anglerep quaternion ?
# No, the problem is a discrepancy between seg and mr. SLANT problem. For now we can resample to seg geom.
data = nibabel.load(a.data_niigz)
labels = nibabel.load(a.labels_niigz)
print(data.affine)
print(' ')
print(labels.affine)
print(' ')
print(f'Max difference: {abs(data.affine-labels.affine).max():7.3}')

means = nilearn.regions.img_to_signals_labels(a.data_niigz,a.labels_niigz,strategy='mean')

print(means)

