# preproc_CALTECH_batch2.sh
# fully reproducible preprocessing analysis pipeline for CALTECH data

# insert subject id you want to process
sublist="0051476"

# insert rootpath were all CALTECH subject data is stored
rootpath=/Users/stavrostrakoshis/Documents/Caltech_scans/

# format speedyppX.py's options
FWHM=6
basetime=10
speedyoptions="-f ${FWHM}mm -o --basetime $basetime --betmask --nobandpass --ss MNI_caez --align_ss --qwarp --rmot --rmotd --keep_means --wds --threshold=10 --SP --OVERWRITE"

# loop over subjects
for subid in $sublist
do
	# path for specific subject to process
	subpath=$rootpath/$subid
	anatpath=$subpath/session_1/anat_1
	restpath=$subpath/session_1/rest_1
	preprocpath=$subpath/session_1/preproc_1
	mkdir $preprocpath

	# create symbolic links to anat and rest in preprocpath
	echo ln -s $restpath/rest.nii.gz $preprocpath >> $preprocpath/${subid}_preproc.sh
	echo ln -s $anatpath/mprage.nii.gz $preprocpath >> $preprocpath/${subid}_preproc.sh

	# cd into subject's directory
	echo cd $preprocpath >> $preprocpath/${subid}_preproc.sh

	# make sure -space field in the header is set to ORIG
	echo 3drefit -space ORIG $preprocpath/mprage.nii.gz >> $preprocpath/${subid}_preproc.sh
	echo 3drefit -space ORIG $preprocpath/rest.nii.gz >> $preprocpath/${subid}_preproc.sh

	# call speedyppX.py
	echo python ~/fmri_spt/speedyppX.py -d rest.nii.gz -a mprage.nii.gz $speedyoptions >> $preprocpath/${subid}_preproc.sh

	# compute framewise displacement
	echo bash ~/fmri_spt/fd.sh -i rest_motion.1D >> $preprocpath/${subid}_preproc.sh

	# compute DVARS
	echo cd $preprocpath/spp.rest >> $preprocpath/${subid}_preproc.sh
	echo bash ~/fmri_spt/dvars.sh -i rest_sm.nii.gz >> $preprocpath/${subid}_preproc.sh
	echo bash ~/fmri_spt/dvars.sh -i rest_noise.nii.gz >> $preprocpath/${subid}_preproc.sh
	echo bash ~/fmri_spt/dvars.sh -i rest_wds.nii.gz >> $preprocpath/${subid}_preproc.sh

	# run complete preprocessing batch script
	bash $preprocpath/${subid}_preproc.sh
	cd $rootpath
done
