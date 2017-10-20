# preproc_CALTECH_batch.sh
# fully reproducible preprocessing analysis pipeline for CALTECH data

# insert subject id you want to process
sublist="0051476"

# insert rootpath were all CALTECH subject data is stored
rootpath=/Users/stavrostrakoshis/Documents/Caltech_scans

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

	# compute framewise displacement with summary statistics
	echo python3 ~/rsfmri-master/fd.py -d rest_motion.1D >> $preprocpath/${subid}_preproc.sh
	
	# cd into spp.rest
	echo cd spp.rest
	
	# compute DVARS with summary statistics
	echo python3 ~/rsfmri-master/dvars_se.py -d rest_sm.nii.gz >> $preprocpath/${subid}_preproc.sh
	echo python3 ~/rsfmri-master/dvars_se.py -d rest_noise.nii.gz >> $preprocpath/${subid}_preproc.sh
	echo python3 ~/rsfmri-master/dvars_se.py -d rest_wds.nii.gz >> $preprocpath/${subid}_preproc.sh


	#echo bash ~/fmri_spt/fd.sh -i rest_motion.1D >> $preprocpath/${subid}_preproc.sh
	#echo cd $preprocpath/spp.rest >> $preprocpath/${subid}_preproc.sh
	#echo bash ~/fmri_spt/dvars.sh -i rest_sm.nii.gz >> $preprocpath/${subid}_preproc.sh
	#echo bash ~/fmri_spt/dvars.sh -i rest_noise.nii.gz >> $preprocpath/${subid}_preproc.sh
	#echo bash ~/fmri_spt/dvars.sh -i rest_wds.nii.gz >> $preprocpath/${subid}_preproc.sh
	#echo python ~/rsfmri-master/fd.py -d rest_motion.1D >> $preprocpath/${subid}_preproc.sh
	#echo python ~/rsfmri-master/dvars_se.py -d rest_sm.nii.gz >> $preprocpath/${subid}_preproc.sh
	
	# run complete preprocessing batch script
	bash $preprocpath/${subid}_preproc.sh
	cd $rootpath
done
#####################################################
#####################################################

# plot_fd_dvars.py looper
for subid in $sublist
do
# path for specific subject to process
    subpath=$rootpath/$subid
    preprocpath=$subpath/session_1/preproc_1
    plotspath=$preprocpath/PLOTS
# make $plotspath
    mkdir $plotspath
    # change directory to $preprocpath
    
    cd $preprocpath
    
    # write commands into bash script
    
    # copy paste fd and dvars txt files into $plotspath
    echo mv rest_motion_fd.txt $plotspath >> $plotspath/plot_motion.sh
    echo mv spp.rest/rest_sm_dvars.txt $plotspath >> $plotspath/plot_motion.sh
    echo mv spp.rest/rest_noise_dvars.txt $plotspath >> $plotspath/plot_motion.sh
    echo mv spp.rest/rest_wds_dvars.txt $plotspath >> $plotspath/plot_motion.sh
    
    # cd into $plotspath
    echo cd $plotspath >> $plotspath/plot_motion.sh
# format arguments for plot_fd_dvars.py
    FD=rest_motion_fd.txt
    DVARSSM=rest_sm_dvars.txt
    DVARSNOISE=rest_noise_dvars.txt
    DVARSWDS=rest_wds_dvars.txt
    plotpyoptions="--fd $FD --dvars_sm $DVARSSM --dvars_noise $DVARSNOISE --dvars_wds $DVARSWDS"
    
    # run plot_fd_dvars.py
    echo python3 ~/fmri_spt/plot_fd_dvars.py $plotpyoptions --pdf2save motion_plot.pdf >> $plotspath/plot_motion.sh
    
    # run bash script
    bash $plotspath/plot_motion.sh

# cd back to $rootpath
    cd $rootpath
done

#####################################################
#####################################################

#!/bin/bash
#Remove unwanted images

# loop over subjects
for subid in $sublist
do
	# Path for each id
	 subpath=$rootpath/$subid
	 preprocpath=$subpath/session_1/preproc_1
	 spprest=$preprocpath/spp.rest

# remove files in preprocpath
	files2remove="mprage*sppdo_at.nii.gz mprage_sppdo.nii.gz *.BRIK *.HEAD *_in*"
	echo cd $preprocpath
	cd $preprocpath
	echo rm -Rf $files2remove
	rm -Rf $preprocpath/$files2remove





#subject id to find file
####################################################
##I cannot stress enough how important it is to write the list correctly! find is recursive and will probably delete whatever is in the rootpath if you don't!

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
	files2remove="mprage*sppdo_at.nii.gz mprage_sppdo.nii.gz *.BRIK *.HEAD *_in*"
	echo cd $preprocpath
	cd $preprocpath
	echo rm -Rf $files2remove
	rm -Rf $preprocpath/$files2remove


	# move files to keep from spp.rest
	files2keep="*dvars.txt *fd.txt PLOTS"
	echo cd $spprest
	cd $spprest
	echo mv $files2keep $preprocpath
	mv $spprest/$files2keep $preprocpath

	# remove spp.rest
	echo cd $preprocpath
	cd $preprocpath
	echo rm -Rf $spprest
	rm -Rf $spprest

	# mkdir for summary statistics

	echo "making summary statistics dir"
	mkdir SS
	echo "moving csvs to SS"
	mv *csv SS
	 
	# cd back to $rootpath
    cd $rootpath
done

