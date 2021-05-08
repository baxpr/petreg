#!/usr/bin/env bash

cd "${out_dir}"

mkdir PDF
cp petreg.pdf PDF

mkdir PET_CSV
cp mrpet_extracted.csv PET_CSV

mkdir MEANPET_CSV
cp mrpet_mean_reg_extracted.csv MEANPET_CSV

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

