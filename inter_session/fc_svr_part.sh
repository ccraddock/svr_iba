argc=$#
argv=("$@")


export AFNI_COMPRESS=GZIP
export PATH=/home/drcc/netspace/afni_bin:$PATH

roimask=/home/drcc/CCB/ROI_SVR_FC/nrenum_g200_clean+tlrc
maskname=/home/drcc/CCB/ROI_SVR_FC/ROI_INV_MASKS/mask_
gmmask=/home/drcc/CCB/ROI_SVR_FC/CCB_mask+tlrc

echo "$argc ${argv[0]} ${argv[1]} ${argv[2]}"
if [ "$argc" -ge "3" ]; then
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

    dset=${argv[1]}
    dset_fnd=0
    # verify that is an apporpriate dataset
    for tdset in REST1 REST2 MSIT1 MSIT2
    do
        if [ "$dset" = "$tdset" ]; then
            dset_fnd=1
        fi
    done
    if [ "$dset_fnd" -ne "1" ]; then
        echo "DSET (${dset}) should be REST1 or REST2 or MSIT1 or MSIT2"
        exit
    fi

    censor=${argv[2]}
    # verify that the censor file exists
    if [ ! -f ${censor} ]; then
        echo "Censor file (${censor}) could not be found"
    fi


    # create a directory for the current analysis and change to it
    censor_prefix=`basename "${censor%.1D}"`
    workdir=${dir}/${censor_prefix}_${dset}
    echo "switching to ${workdir} to continue"
    mkdir -p "${workdir}"
    cd "${workdir}"

    obs_TC_dir=${workdir}/${dset}_obs_TCs
    if [ ! -d ${obs_TC_dir} ]; then
        mkdir -p ${obs_TC_dir}
    fi

    # set all of the prefixes for the analysis
    prefix=${workdir}/swnmrda${subjid}_scan${scannum}_${dset}_${scandate}
    dataname=${dir}/swnmrda${subjid}_scan${scannum}_${dset}_${scandate}+tlrc
    tcname=${obs_TC_dir}/swnmrda${subjid}_scan${scannum}_${dset}_TCs

    zprefix=${dir}/zswnmrda${subjid}_scan${scannum}_${dset}_${scandate}
    zdataname=${dir}/zswnmrda${subjid}_scan${scannum}_${dset}_${scandate}+tlrc

    # zscore dataset
    if [ ! -f ${zdataname}.HEAD ]; then
        if [ ! -f ${dir}/mean_${dset}+tlrc.HEAD ]; then
            3dTstat -prefix ${dir}/mean_${dset} -mask ${gmmask} -mean ${dataname}
        fi
        if [ ! -f ${dir}/sd_${dset}+tlrc.HEAD ]; then
            3dTstat -prefix ${dir}/sd_${dset} -mask ${gmmask} -stdev ${dataname}
        fi
        3dcalc -prefix ${zprefix} -a ${dataname} -b ${dir}/mean_${dset}+tlrc \
            -c ${dir}/sd_${dset}+tlrc -expr '(a-b)/c'
        rm ${dir}/sd_${dset}+tlrc*
        rm ${dir}/mean_${dset}+tlrc*
        #gzip ${zdataname}.BRIK
    fi


    # get all of the timecourses
    for (( i=1; i<180; i++ ))
    do
        if [ ! -f ${tcname}_${i}.1D ]; then 
            3dmaskave -mask $roimask -quiet -mrange $i $i ${zdataname} > ${tcname}_${i}.1D
        fi
        3dsvm -type regression -c 100 -e 0.001 \
              -trainvol ${dataname} \
              -trainlabels ${tcname}_${i}.1D \
              -censor ${censor} \
              -mask ${maskname}${i}+tlrc \
              -model ${prefix}_model_${i} \
              -bucket ${prefix}_w_${i}
    
        #gzip ${prefix}_model_${i}+tlrc.BRIK
    
        # now do the predictions
        for pdset in REST1 REST2 MSIT1 MSIT2
        do
            if [ "$pdset" != "$dset" ]; then
                pdataname=$dir/swnmrda${subjid}_scan${scannum}_${pdset}_${scandate}+tlrc
                ff=${subjid}_scan${scannum}_${pdset}
 
                echo "${pdataname} - > ${ff}" 
                3dsvm_linpredict -mask ${maskname}${i}+tlrc \
                      -model ${prefix}_model_${i}+tlrc \
                      ${pdataname} ${prefix}_w_${i}+tlrc > ${prefix}_pred_${ff}_${i}.1D
            fi
        done

        # conserve space by deleting model BRIK (retain HEAD) and
        # mask files
        rm -f ${prefix}_model_${i}+tlrc.BRIK*
        rm -f ${prefix}_model_${i}_mask+tlrc.*

        # gzip bucket if not already done
        #gzip ${prefix}_w_${i}+tlrc.BRIK
        #fi
    done

    # archive all of the W and model HEAD files
    tar cjf ${prefix}_models.tar.bz2 *_w_* *_model_*
    rm -f *_w_* *_model_*

    # archive the predicted TCs
    tar cjf ${prefix}_pred_TCs.tar.bz2 *_pred_*.1D
    rm -f *_pred_*.1D

    rm -f *.1D
    rm -f mask_*
    #rm -f z*
fi
