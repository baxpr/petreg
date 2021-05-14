#!/usr/bin/env bash

# Copy files to outdir / working dir. Use convenient filenames so
# we can just hardcode the filenames later.
echo "Copying inputs"
cp "${pet_niigz}" "${out_dir}"/pet.nii.gz
cp "${ct_niigz}" "${out_dir}"/ct.nii.gz
cp "${mr_niigz}" "${out_dir}"/mr.nii.gz
cp "${seg_niigz}" "${out_dir}"/seg.nii.gz
