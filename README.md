# PET to MR registration via CT

Preprocessing and extraction of data from regions in a PET image, using FSL. Regions are derived
from a MultiAtlas segmentation (https://github.com/VUIIS/Multi-Atlas-v3.0.0, 
https://github.com/MASILab/SLANTbrainSeg).

1. Motion correction applied to PET time series (`mcflirt`, 6 dof)
2. Mean PET registered to CT (`flirt`, 6 dof)
3. CT registered to MR (`flirt`, default 6 dof)
4. SUVR calculated from summed PET image, referenced to cerebellum
4. PET regional values extracted with nilearn

## Inputs

The command line is

    petreg.sh <arguments>

And `<arguments>` are below. The first four are required:

	--pet_niigz       PET time series
    --ct_niigz        CT
    --mr_niigz        MR (typically T1W)
    --seg_niigz       Segmentation of MR from multi-atlas / slant
	
	--ctmr_dof        DOF for CT/MR registration (default 6)
    
    --project         Information from XNAT, if used (optional). These
	--subject           are only used to annotate the PDF QA report.
	--session
	--scan
    
    --out_dir         Where outputs will be stored (default /OUTPUTS)
	
    --labels_csv      Labels corresponding to seg_niigz. Optional argument
	                    only needed in special circumstances.


## Outputs

All output images have been resampled to the field of view, voxel size,
and geometry of the MR.

    CT_REG                   CT registered to MR
    CT_REG_MAT               Transform from CT to MR (FSL format)
    MEANPET_REG              Mean PET registered to MR
	MOT_PARAMS               PET time series motion parameters (FSL format)
    PDF                      QA report
    PET_REG                  PET time series registered to MR
    PET_REG_MAT              Transform from PET to MR (FSL format)
    PET_ROI_MEANS            ROI means of PET time series
    PET_ROI_SDEVS            ROI std devs of PET time series
    ROIS                     ROI image
    ROI_LABELS               ROI label names
    SUM_REG                  Sum of PET images over time
    SUM_ROI_MEANS            ROI means of summed image
    SUM_ROI_SDEVS            ROI std devs of summed image
    SUVR_REG                 SUVR image calculated from summed image
    SUVR_ROI_MEANS           ROI means of SUVR image
    SUVR_ROI_SDEVS           ROI std devs of SUVR image


## References

* FSL: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki
* MCFLIRT: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/MCFLIRT
* FLIRT: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FLIRT#References
* nilearn: https://nilearn.github.io/authors.html#citing
* MultiAtlas: https://pubmed.ncbi.nlm.nih.gov/23265798/
* SLANT: https://pubmed.ncbi.nlm.nih.gov/30910724/
