argc=$#
argv=("$@")


export AFNI_COMPRESS=GZIP
export PATH=/home/drcc/netspace/afni_bin:$PATH

roimask=/home/drcc/CCB/ROI_SVR_FC/nrenum_g200_clean+tlrc
maskname=/home/drcc/CCB/ROI_SVR_FC/ROI_INV_MASKS/mask_
gmmask=/home/drcc/CCB/ROI_SVR_FC/CCB_mask+tlrc

echo "$argc ${argv[0]} ${argv[1]}"
if [ "$argc" -ge "2" ]; then
    dir=${argv[0]}
    # verify that the file exists, is appropriate, and parse out 
    # relevant information
    if [ -d ${dir} ]; then
        if [[ ${dir} =~ '(\w*)_scan([0-9])_([0-9]*)' ]]; then
            if [[ ${#BASH_REMATCH[*]} -eq 4 ]]; then
                subjid=${BASH_REMATCH[1]}
                scannum=${BASH_REMATCH[2]}
                scandate=${BASH_REMATCH[3]}
                echo "${dir} => (${subjid} ${scannum} ${scandate}"
            else
                echo "$dir could not be parsed"
                continue
            fi
            echo "$dir parsed into $subjid"
        else
            echo "$dir does not match"
            continue
        fi
    else
        echo "$dir does not exist" 
        continue
    fi

    censor=${argv[1]}

    # create a directory for the current analysis and change to it
    workdir=${dir}/${censor}_reproducibility
    echo "switching to ${workdir} to continue"
    mkdir -p "${workdir}"
    cd "${workdir}"

    for dset in REST1 REST2
    do
        # verify that the censor directories exist
        if [ ! -d ${dir}/${censor}_${dset} ]; then
            echo "Censor dirctory ${dir}/${censor}_${dset} could not be found"
        fi

        # if compressed ROI tcs exist, uncompress them
        prefix=swnmrda${subjid}_scan${scannum}_${dset}_${scandate}
        if [ -f ${dir}/${censor}_${dset}/${prefix}_models.tar.bz2 ]; then
            tar xjf ${dir}/${censor}_${dset}/${prefix}_models.tar.bz2
        else
            echo "Could not find model tarfile (${dir}/${censor}_${dset}/${prefix}_models.tar.bz2)!"
            exit
        fi
    done

    # set all of the prefixes for the analysis
    rest1_w_prefix=${workdir}/swnmrda${subjid}_scan${scannum}_REST1_${scandate}_w_
    rest2_w_prefix=${workdir}/swnmrda${subjid}_scan${scannum}_REST2_${scandate}_w_
    outname=${dir}/${subjid}_scan${scannum}_${censor}_REST_rep.1D

    echo "##ROINAME,predR,predC" > ${outname}
    # get all of the timecourses
    for (( i=1; i<180; i++ ))
    do
        predR=`3ddot -demean ${rest1_w_prefix}${i}+tlrc ${rest2_w_prefix}${i}+tlrc`
        predC=`3ddot -doconc ${rest1_w_prefix}${i}+tlrc ${rest2_w_prefix}${i}+tlrc`
        echo "${i},${predR},${predC}" >> ${outname}

    done

    cd ${dir}
    rm -rf ${workdir} 
fi
