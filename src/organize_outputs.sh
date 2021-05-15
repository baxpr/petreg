#!/usr/bin/env bash

cd "${out_dir}"

mkdir PDF
cp petreg.pdf PDF

mkdir PET_REG
cp mrpet.nii.gz PET_REG

mkdir PET_ROI_MEANS
cp mrpet_means.csv PET_ROI_MEANS

mkdir PET_ROI_SDEVS
cp mrpet_sdevs.csv PET_ROI_SDEVS

mkdir SUMPET_REG
cp mrpet_sum.nii.gz SUMPET_REG

mkdir SUMPET_ROI_MEANS
cp mrpet_sum_means.nii.gz SUMPET_ROI_MEANS

mkdir SUMPET_ROI_SDEVS
cp mrpet_sum_sdevs.nii.gz SUMPET_ROI_SDEVS

mkdir SUMPET_SUVR_REG
cp mrpet_suvr.nii.gz SUMPET_SUVR_REG

mkdir SUMPET_SUVR_ROI_MEANS
cp mrpet_suvr_means.nii.gz SUMPET_SUVR_ROI_MEANS

mkdir SUMPET_SUVR_ROI_SDEVS
cp mrpet_suvr_sdevs.nii.gz SUMPET_SUVR_ROI_SDEVS

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
