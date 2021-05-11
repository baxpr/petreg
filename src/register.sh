#!/usr/bin/env bash

# Copy files to outdir / working dir. Use convenient filenames so
# we can just hardcode the filenames below.
echo "Copying inputs"
cp "${pet_niigz}" "${out_dir}"/pet.nii.gz
cp "${ct_niigz}" "${out_dir}"/ct.nii.gz
cp "${mr_niigz}" "${out_dir}"/mr.nii.gz
cp "${seg_niigz}" "${out_dir}"/seg.nii.gz
cd "${out_dir}"

# Initial PET motion correction
echo "Within-series PET registration"
mcflirt -in pet -out rpet -meanvol -plots

# Register mean PET to CT (usesqform is crucial)
echo "Register mean PET to CT"
flirt -usesqform -dof 6 -in rpet_mean_reg -ref ct -omat rpet_to_ct.mat

# Register CT to MR (usesqform is crucial)
echo "Register CT to MR"
flirt -usesqform -dof 6 -cost normmi -in ct -ref seg -out mct -omat ct_to_mr.mat

# Combine PET-CT and CT-MR transforms
echo "Combine transforms"
convert_xfm -omat rpet_to_mr.mat -concat ct_to_mr.mat rpet_to_ct.mat

# Apply registration to PET means and PET series (to MR space)
echo "Apply registration"
flirt -in rpet_mean_reg -ref seg -init rpet_to_mr.mat -applyxfm -out mrpet_mean_reg
flirt -in rpet -ref seg -init rpet_to_mr.mat -applyxfm -out mrpet

# Extract ROI values
roi_extract.py \
	--labels_niigz seg.nii.gz \
	--labels_csv ${labels_csv} \
	--data_niigz mrpet.nii.gz \


