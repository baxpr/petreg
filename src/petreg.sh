#!/usr/bin/env bash
#
# Pipeline to coregister PET, CT, MR and extract regional PET values

# Initialize defaults (will be changed later if passed as options)
export project=NO_PROJ
export subject=NO_SUBJ
export session=NO_SESS
export scan=NO_SCAN
export labels_csv=/opt/petreg/src/multiatlas_labels_grouped.csv
export out_dir=/OUTPUTS

# Parse options
while [[ $# -gt 0 ]]; do
	key="${1}"
	case $key in
		--project)
			export project="${2}"; shift; shift ;;
		--subject)
			export subject="${2}"; shift; shift ;;
		--session)
			export session="${2}"; shift; shift ;;
		--scan)
			export scan="${2}"; shift; shift ;;
		--pet_niigz)
			export pet_niigz="${2}"; shift; shift ;;
		--ct_niigz)
			export ct_niigz="${2}"; shift; shift ;;
		--mr_niigz)
			export mr_niigz="${2}"; shift; shift ;;
		--seg_niigz)
			export seg_niigz="${2}"; shift; shift ;;
		--labels_csv)
			export labels_csv="${2}"; shift; shift ;;
		--out_dir)
			export out_dir="${2}"; shift; shift ;;
		*)
			echo Unknown input "${1}"; shift ;;
	esac
done

# FSL setup. Relies on FSLDIR being set already
. ${FSLDIR}/etc/fslconf/fsl.sh
export PATH=${FSLDIR}/bin:${PATH}

# Copy inputs
prep_files.sh

# Fix seg header to exactly match mr - compensate for tiny error in SLANT that
# causes issues with nilearn.regions
fslcpgeom "${out_dir}"/mr "${out_dir}"/seg

# Create our desired ROIs from multiatlas labels
combine_rois.py --seg_niigz "${out_dir}"/seg.nii.gz --groups_csv "${labels_csv}" \
	--out_pfx "${out_dir}"/nseg

# Registration of PET, CT, MR
register.sh

# Regional values for time series and for sum
roi_extract.py --labels_niigz "${out_dir}"/nseg.nii.gz --labels_csv "${out_dir}"/nseg.csv \
	--data_niigz "${out_dir}"/mrpet.nii.gz --out_pfx "${out_dir}/mrpet_"
roi_extract.py --labels_niigz "${out_dir}"/nseg.nii.gz --labels_csv "${out_dir}"/nseg.csv \
	--data_niigz "${out_dir}"/mrpet_sum.nii.gz --out_pfx "${out_dir}/mrpet_sum_"

# SUVR normalization for sum image
cerval=$(get_cerebellum.py --roivals_csv "${out_dir}"/mrpet_sum_means.csv)
fslmaths mrpet_sum -div ${cerval} mrpet_suvr

# Regional values for SUVR
roi_extract.py --labels_niigz "${out_dir}"/nseg.nii.gz --labels_csv "${out_dir}"/nseg.csv \
	--data_niigz "${out_dir}"/mrpet_suvr.nii.gz --out_pfx "${out_dir}/mrpet_suvr_"

# Report
make_pdf.sh

# Organize for DAX
organize_outputs.sh
