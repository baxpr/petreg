#!/usr/bin/env bash
#
# Pipeline to coregister PET, CT, MR and extract regional PET values

# Initialize defaults (will be changed later if passed as options)
export project=NO_PROJ
export subject=NO_SUBJ
export session=NO_SESS
export scan=NO_SCAN
export labels_csv=/opt/petreg/src/multiatlas_labels.csv
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

# Run the pipeline
register.sh
make_pdf.sh
organize_outputs.sh
