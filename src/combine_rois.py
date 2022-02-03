#!/usr/bin/env python

import argparse
import nibabel
import numpy
import pandas

# Parse inputs
p = argparse.ArgumentParser()
p.add_argument('--seg_niigz', help='Multiatlas segmentation', required=True)
p.add_argument('--groups_csv', help='Multiatlas ROI groupings', required=True)
p.add_argument('--out_pfx', help='Output prefix, including path', required=True)
a = p.parse_args()

# Read our seg image
img_seg = nibabel.load(a.seg_niigz)
data_seg = numpy.around(img_seg.get_fdata())

# Load the groupings, drop ungrouped, and identify unique groups
groups = pandas.read_csv(a.groups_csv)
groups = groups.loc[groups.Group.notna(),:]
rois = groups.Group.unique()
rois.sort()

# Create the refactored ROI image and its corresponding label file
data_roi = numpy.zeros(img_seg.shape)
Label = list()
Region = list()
k = 0
for roi in rois:
    k = k + 1
    Region.append(roi)
    Label.append(k)
    matchlabels = groups.Label[numpy.isin(groups.Group,roi)]
    ind = numpy.isin(data_seg,matchlabels)
    data_roi[ind] = k

labels_roi = pandas.DataFrame(list(zip(Label, Region)),columns =['Label', 'Region'])
labels_roi.to_csv(f'{a.out_pfx}.csv',index=False)

roi_img = nibabel.nifti1.Nifti1Image(data_roi, affine=img_seg.affine, header=img_seg.header)
roi_img.to_filename(f'{a.out_pfx}.nii.gz')

# Also create a binary mask of brain
data_brain = (data_roi > 0).astype(int)
data_img = nibabel.nifti1.Nifti1Image(data_brain, affine=img_seg.affine, header=img_seg.header)
data_img.to_filename(f'{a.out_pfx}-brain.nii.gz')
