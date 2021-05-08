# PET to MR registration via CT

Preprocessing and extraction of data from regions in a PET image, using FSL.

1. Motion correction applied to PET time series (`mcflirt`)
2. Mean PET registered to CT (`flirt` 6 dof)
3. CT registered to MR (`flirt` 6 dof)
4. PET regional values extracted using the supplied MR segmentation (`fslmeants`)

## Inputs

The command line is

    petreg.sh <inputs>

And `<inputs>` are

	--pet_niigz       PET time series
    --ct_niigz        CT
    --mr_niigz        MR (typically T1W)
    --seg_niigz       Segmentation of MR, e.g. multi-atlas / slant
    --labels_csv      Labels corresponding to seg_niigz
    
    --project         Information from XNAT, if used (optional). These
	--subject           are only used to annotate the PDF QA report.
	--session
	--scan
    
    --out_dir         Where outputs will be stored (default /OUTPUTS)

The `labels_csv` file must have a specific format like so:

    1,
    2,
    3,
    4,3rd Ventricle
    5,
    6,
    ...
    207,Left TTG transverse temporal gyrus

All numbers from 1 to the maximum label value must be included, as shown, as that is how 
`fslmeants` extracts regional values. Regions with a value but no text label will be 
dropped from the final output. If nothing is supplied for this input, a default `label_csv` 
will be used that matches MultiAtlas/SLANT.

## Outputs

    PDF               QA report
    PET_CSV           Regional values extracted from PET time series
    MEANPET_CSV       Regional values extracted from mean PET
    PET_REG           PET time series registered to MR
    MEANPET_REG       Mean PET registered to MR
    PET_REG_MAT       Transform from PET to MR (FSL format)
    CT_REG            CT registered to MR
    CT_REG_MAT        Transform from CT to MR (FSL format)



