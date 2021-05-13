#!/usr/bin/env python

import argparse
import nibabel
import numpy
import pandas

# New ROIs from multiatlas labels
rois = {
    'Cerebellum': (1, [38,39,40,41,71,72,73] ),
    'Ventricle':  (2, [4,11,49,50,51,52]     ),
}

# Parse inputs
p = argparse.ArgumentParser()
p.add_argument('--seg_niigz', help='Multiatlas segmentation', required=True)
p.add_argument('--out_pfx', help='Output prefix', required=True)
a = p.parse_args()

# Read our seg image
img_seg = nibabel.load(a.seg_niigz)
data_seg = numpy.around(img_seg.get_fdata())
affine_seg = img_seg.affine

# Create the refactored ROI image and its corresponding label file
data_roi = numpy.zeros(img_seg.shape)
Label = list()
Region = list()
for roi in rois:
    Region.append(roi)
    Label.append(rois[roi][0])
    ind = numpy.isin(data_seg,rois[roi][1])
    data_roi[ind] = rois[roi][0]

labels_roi = pandas.DataFrame(list(zip(Label, Region)),columns =['Label', 'Region'])
labels_roi.to_csv(f'{a.out_pfx}.csv',index=False)

roi_img = nibabel.nifti1.Nifti1Image(data_roi,affine_seg)
roi_img.to_filename(f'{a.out_pfx}.nii.gz')

