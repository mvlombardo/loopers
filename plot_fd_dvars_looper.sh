#!bin/bash/
# plot_fd_dvars.py looper

# insert subject id you want to process
sublist="0051456_copy 0051457_copy"

# insert rootpath were all CALTECH subject data is stored
rootpath=/Users/stavrostrakoshis/Documents/Caltech_scans/



# loop over subjects
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

    # format plot_fd_dvars.py's options
    
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
