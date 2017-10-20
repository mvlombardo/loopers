#!/bin/bash
#Remove unwanted images

#subject id to find file
####################################################
##I cannot stress enough how important it is to write the list correctly! find is recursive and will probably delete whatever is in the rootpath if you don't!
sublist="0051465 0051466"

# insert rootpath were all CALTECH subject data is stored
rootpath=/Users/stavrostrakoshis/Documents/Caltech_scans

# loop over subjects
for subid in $sublist
do
	# Path for each id
	 subpath=$rootpath/$subid
	 preprocpath=$subpath/session_1/preproc_1
	 spprest=$preprocpath/spp.rest
	################################
	# Change mode to read \!
	################################
	echo shopt -s extglob
	shopt -s extglob
	################################
	#cd into directory and remove them
	echo cd $preprocpath
	cd $preprocpath
	echo Moving
	mv rest.nii.gz rest222.nii.gz; mv mprage.nii.gz mprage_222.nii.gz;
	echo find . \! -name '*222*' -delete -maxdepth 1
	find . \! -name '*222*' -delete -maxdepth 1
	####################################################
	##Into spp.rest
	echo cd $spprest
	cd $spprest
	echo deleting inside spp.rest
	find . -delete
	################################
	#Delete empty spp.rest dir
	cd $preprocpath
	echo rmdir spp.rest
	rmdir spp.rest
	##Change back to normal
	echo shopt -u extglob
	shopt -u extglob
	##Renaming
	mv rest222.nii.gz rest.nii.gz; mv mprage_222.nii.gz mprage.nii.gz
	echo backtorootpath
	cd $rootpath
done