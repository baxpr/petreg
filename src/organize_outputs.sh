#!/usr/bin/env bash

cd "${out_dir}"

mkdir PDF
cp petreg.pdf PDF

mkdir PET_ROI_MEANS
cp means.csv PET_ROI_MEANS

mkdir PET_ROI_SDEVS
cp sdevs.csv PET_ROI_SDEVS

mkdir PET_REG
cp mrpet.nii.gz PET_REG

mkdir MEANPET_REG
cp mrpet_mean_reg.nii.gz MEANPET_REG

mkdir PET_REG_MAT
cp rpet_to_mr.mat PET_REG_MAT

mkdir CT_REG
cp mct.nii.gz CT_REG

mkdir CT_REG_MAT
cp ct_to_mr.mat CT_REG_MAT

mkdir ROIS
cp nseg.nii.gz ROIS

mkdir ROI_LABELS
cp nseg.csv ROI_LABELS
