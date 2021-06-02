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

mkdir SUM_REG
cp mrpet_sum.nii.gz SUM_REG

mkdir SUM_ROI_MEANS
cp mrpet_sum_means.csv SUM_ROI_MEANS

mkdir SUM_ROI_SDEVS
cp mrpet_sum_sdevs.csv SUM_ROI_SDEVS

mkdir SUVR_REG
cp mrpet_suvr.nii.gz SUVR_REG

mkdir SUVR_ROI_MEANS
cp mrpet_suvr_means.csv SUVR_ROI_MEANS

mkdir SUVR_ROI_SDEVS
cp mrpet_suvr_sdevs.csv SUVR_ROI_SDEVS

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

mkdir MOT_PARAMS
cp rpet.par MOT_PARAMS
