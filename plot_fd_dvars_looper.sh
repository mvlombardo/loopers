# plot_fd_dvars.py looper
#doesn't work with links (ln) in Sierra

# insert subject id you want to process
sublist="0051469_copy 0051470_copy"

# insert rootpath were all CALTECH subject data is stored
rootpath=/Users/stavrostrakoshis/Documents/Caltech_scans/



# loop over subjects
for subid in $sublist
do
    # path for specific subject to process
    subpath=$rootpath/$subid
    preprocpath=$subpath/session_1/preproc_1
    plotspath=$preprocpath/PLOTS
    mkdir $plotspath
    cd $preprocpath
    cp rest_motion_fd.txt $plotspath #>> $plotspath/plot_motion.sh
    cp spp.rest/rest_sm_dvars.txt $plotspath #>> $plotspath/plot_motion.sh
    cp spp.rest/rest_noise_dvars.txt $plotspath #>> $plotspath/plot_motion.sh
    cp spp.rest/rest_wds_dvars.txt $plotspath #>> $plotspath/plot_motion.sh
    cd $plotspath #>> $plotspath/plot_motion.sh

    # format plot_fd_dvars.py's options
    
    FD=rest_motion_fd.txt
    DVARSSM=rest_sm_dvars.txt
    DVARSNOISE=rest_noise_dvars.txt
    DVARSWDS=rest_wds_dvars.txt
    plotpyoptions="--fd $FD --dvars_sm $DVARSSM --dvars_noise $DVARSNOISE --dvars_wds $DVARSWDS"
    python ~/fmri_spt/plot_fd_dvars.py $plotpyoptions --pdf2save motion_plot.pdf >> $plotspath/plot_motion.sh
    bash plot_motion.sh
    cd $rootpath
done