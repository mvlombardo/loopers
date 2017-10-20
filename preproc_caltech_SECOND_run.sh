#!/bin/bash
# preproc_CALTECH_batch2.sh
# fully reproducible preprocessing analysis pipeline for CALTECH data

# insert subject id you want to process
sublist="0051489 0051491 0051493"

# insert rootpath were all CALTECH subject data is stored
rootpath=/Users/stavrostrakoshis/Documents/Caltech_scans

# format speedyppX.py's options
FWHM=6
basetime=10
speedyoptions="-f ${FWHM}mm -o --coreg_cfun=lpc+ --basetime $basetime --betmask --nobandpass --ss MNI_caez --align_ss --qwarp --rmot --rmotd --keep_means --wds --threshold=10 --SP --OVERWRITE"

# loop over subjects
for subid in $sublist
do
	# path for specific subject to process
	subpath=$rootpath/$subid
	anatpath=$subpath/session_1/anat_1
	restpath=$subpath/session_1/rest_1
	preprocpath=$subpath/session_1/preproc_2
	mkdir $preprocpath

	# create symbolic links to anat and rest in preprocpath
	echo ln -s $restpath/rest.nii.gz $preprocpath >> $preprocpath/${subid}_preproc.sh
	#cp $restpath/rest.nii.gz $preprocpath
	echo ln -s $anatpath/mprage.nii.gz $preprocpath >> $preprocpath/${subid}_preproc.sh
	#cp $anatpath/mprage.nii.gz $preprocpath
	
	# cd into subject's directory
	echo cd $preprocpath >> $preprocpath/${subid}_preproc.sh
	#cd $preprocpath
	
	# make sure -space field in the header is set to ORIG
	echo 3drefit -space ORIG $preprocpath/mprage.nii.gz >> $preprocpath/${subid}_preproc.sh
	#3drefit -space ORIG $preprocpath/mprage.nii.gz
	echo 3drefit -space ORIG $preprocpath/rest.nii.gz >> $preprocpath/${subid}_preproc.sh
	#3drefit -space ORIG $preprocpath/rest.nii.gz
	
	# call speedyppX.py
	echo python ~/rsfmri-master/speedyppX.py -d rest.nii.gz -a mprage.nii.gz $speedyoptions >> $preprocpath/${subid}_preproc.sh
	#python ~/rsfmri-master/speedyppX.py -d rest.nii.gz -a mprage.nii.gz $speedyoptions 
	
	# compute framewise displacement with summary statistics
	echo python ~/rsfmri-master/fd.py -d rest_motion.1D >> $preprocpath/${subid}_preproc.sh
	#python3 ~/rsfmri-master/fd.py -d rest_motion.1D
	
	#cd into spp.rest
	echo cd spp.rest >> $preprocpath/${subid}_preproc.sh
	#cd spp.rest
	
	# compute DVARS
	echo python ~/rsfmri-master/dvars_se.py -d rest_sm.nii.gz >> $preprocpath/${subid}_preproc.sh
	#python3 ~/rsfmri-master/dvars_se.py -d rest_sm.nii.gz
	
	echo python ~/rsfmri-master/dvars_se.py -d rest_noise.nii.gz >> $preprocpath/${subid}_preproc.sh
	#python3 ~/rsfmri-master/dvars_se.py -d rest_noise.nii.gz
	
	echo python ~/rsfmri-master/dvars_se.py -d rest_wds.nii.gz >> $preprocpath/${subid}_preproc.sh
	#python3 ~/rsfmri-master/dvars_se.py -d rest_wds.nii.gz
	
	# run complete preprocessing batch script
	bash $preprocpath/${subid}_preproc.sh
	
	cd $rootpath
done
