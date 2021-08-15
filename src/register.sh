#!/usr/bin/env bash

cd "${out_dir}"

# Initial PET motion correction
echo "Within-series PET registration"
mcflirt -in pet -out rpet -meanvol -plots

# Register CT to mean PET (usesqform is crucial)
echo "Register CT to mean PET"
flirt -usesqform -dof 6 -in ct -ref rpet_mean_reg -omat ct_to_rpet.mat

# Register mean PET to MR (usesqform is crucial)
echo "Register mean PET to MR"
flirt -usesqform -dof ${petmr_dof} -cost normmi \
    -in rpet_mean_reg -ref mr -out mrpet_mean_reg -omat rpet_to_mr.mat

# Combine CT-PET and PET-MR transforms
echo "Combine transforms"
convert_xfm -omat ct_to_mr.mat -concat rpet_to_mr.mat ct_to_rpet.mat

# Apply registration to CT and to PET series (to MR space)
echo "Apply registration"
flirt -in ct -ref mr -init ct_to_mr.mat -applyxfm -out mct
flirt -in rpet -ref mr -init rpet_to_mr.mat -applyxfm -out mrpet

# Compute sum image
numvols=$(fslval mrpet dim4)
fslmaths mrpet_mean_reg -mul ${numvols} mrpet_sum
