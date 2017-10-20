#!/bin/bash
#Remove unwanted images

#subject id to find file
####################################################
##I cannot stress enough how important it is to write the list correctly! find is recursive and will probably delete whatever is in the rootpath if you don't!
sublist="0051456_copy"

# insert rootpath were all CALTECH subject data is stored
rootpath=/Users/stavrostrakoshis/Documents/Caltech_scans


# loop over subjects
for subid in $sublist
do
	# Path for each id
	 subpath=$rootpath/$subid
	 preprocpath=$subpath/session_1/preproc_1
	 spprest=$preprocpath/spp.rest
	 #dontdelete="rest_pp.nii.gz, mprage_sppdo_atnl.nii.gz"
	 #mkdir $preprocpath/shallnotdelete
	
	# remove files in preprocpath
	files2remove="mprage*sppdo_at.nii.gz mprage_sppdo.nii.gz *.BRIK *.HEAD *_in* *1D"
	echo cd $preprocpath
	cd $preprocpath
	echo rm -Rf $files2remove
	rm -Rf $preprocpath/$files2remove


	# move files to keep from spp.rest
	files2keep="*txt *txt *csv PLOTS"
	echo cd $spprest
	cd $spprest
	echo mv $files2keep $preprocpath
	mv $spprest/$files2keep $preprocpath

	# remove spp.rest
	echo cd $preprocpath
	cd $preprocpath
	echo rm -Rf $spprest
	rm -Rf $spprest
	echo "csv directory is made"
	mkdir CSV
	echo "moving csvs"
	mv *csv CSV
	echo backtorootpath
	cd $rootpath
	
	# # Change mode to read \!
	# echo shopt -s extglob
	# shopt -s extglob
	# #cd into directory and remove them
	# echo cd $preprocpath
	# cd $preprocpath
	# echo Moving files to safety
	# cp rest_pp.nii.gz rest_pp222.nii.gz; cp mprage_sppdo_atnl.nii.gz mprage_sppdo_atnl222.nii.gz; mv $spprest/PLOTS ./PLOTS222
	# echo find . \! -name '*222*' -delete -maxdepth 1
	# find . \! -name '*222*' -delete -maxdepth 1
	# ####################################################
	# ##Into spp.rest
	# echo cd $spprest
	# cd $spprest
	# echo deleting inside spp.rest
	# find . -delete
	# ################################
	# #Delete empty spp.rest dir
	# cd $preprocpath
	# echo rmdir spp.rest
	# rmdir spp.rest
	# ##Change back to normal
	# mv rest_pp222.nii.gz rest_pp.nii.gz; mv mprage_sppdo_atnl222.nii.gz mprage_sppdo_atnl.nii.gz; mv PLOTS222 PLOTS
	# echo shopt -u extglob
	# shopt -u extglob
	# echo backtorootpath
	# cd $rootpath
done
