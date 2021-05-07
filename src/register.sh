#!/usr/bin/env bash
#
# Outputs:
#
#    mr.nii.gz                Original MR
#    seg.nii.gz               Original MR segmentation (multiatlas)
#    ct.nii.gz                Original CT
#    pet.nii.gz              Original PET series
# 
#    ct_to_mr.mat            Transform from CT to MR
#    rpet_to_ct.mat         Transform from motion-corrected PET to CT
#    rpet_to_mr.mat         Transform from motion-corrected PET to MR
# 
#    rpet_mean_reg.nii.gz    Mean PET after motion correction
#    rpet.nii.gz             PET series after motion correction
#
#    mrpet_mean_reg.nii.gz   Same as above, but registered to MR
#    mrpet.nii.gz


# Copy files to outdir / working dir. Use convenient filenames so
# we can just hardcode the filenames below.
cp ${pet_niigz} ${out_dir}/pet.nii.gz
cp ${ct_niigz} ${out_dir}/ct.nii.gz
cp ${mr_niigz} ${out_dir}/mr.nii.gz
cp ${seg_niigz} ${out_dir}/seg.nii.gz

# Change to working dir (saves typing below)
cd ${out_dir}

# Within-series registration for PET
mcflirt -in pet -out rpet -meanvol -plots

# Register mean PET to CT (usesqform is crucial)
flirt -usesqform -dof 6 -in rpet_mean_reg -ref ct -omat rpet_to_ct.mat

# Register CT to MR (usesqform is crucial)
flirt -usesqform -dof 6 -cost normmi -in ct -ref mr -out mct -omat ct_to_mr.mat

# Combine PET-CT and CT-MR transforms
convert_xfm -omat rpet_to_mr.mat -concat ct_to_mr.mat rpet_to_ct.mat

# Apply registration to PET means and PET series (to MR space)
flirt -in rpet_mean_reg -ref mr -init rpet_to_mr.mat -applyxfm -out mrpet_mean_reg
flirt -in rpet -ref mr -init rpet_to_mr.mat -applyxfm -out mrpet

# Extract PET values from seg (multiatlas) regions
#fslstats -t -K seg mrpet -c -v -m
