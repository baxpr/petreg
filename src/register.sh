#!/usr/bin/env bash

cd "${out_dir}"

# Initial PET motion correction
echo "Within-series PET registration"
mcflirt -in pet -out rpet -meanvol -plots

# Register mean PET to CT (usesqform is crucial)
echo "Register mean PET to CT"
flirt -usesqform -dof 6 -in rpet_mean_reg -ref ct -omat rpet_to_ct.mat

# Register CT to MR (usesqform is crucial)
echo "Register CT to MR"
flirt -usesqform -dof 6 -cost normmi -in ct -ref mr -out mct -omat ct_to_mr.mat

# Combine PET-CT and CT-MR transforms
echo "Combine transforms"
convert_xfm -omat rpet_to_mr.mat -concat ct_to_mr.mat rpet_to_ct.mat

# Apply registration to PET means and PET series (to MR space)
echo "Apply registration"
flirt -in rpet_mean_reg -ref mr -init rpet_to_mr.mat -applyxfm -out mrpet_mean_reg
flirt -in rpet -ref mr -init rpet_to_mr.mat -applyxfm -out mrpet

