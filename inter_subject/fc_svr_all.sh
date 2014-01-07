argc=$#
argv=("$@")

export AFNI_COMPRESS=GZIP
export PATH=/home/ccraddock/netspace/afni_bin:$PATH

echo "$argc ${argv[0]}"

for (( i=0; i<argc; i++ ))
do
    dir=${argv[$i]}
    # verify that the file exists, is appropriate, and parse out 
    # relevant information
    if [ -d ${dir} ]; then
        if [[ ${dir} =~ '[0-9]+_[a-zA-Z]*' ]]; then
            if [[ ${#BASH_REMATCH[*]} -eq 1 ]]; then
                subjid=${BASH_REMATCH[0]}
                echo "$subjid"
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

    prefix=$dir/swnmrda${subjid}_rest
    dataname=$dir/swnmrda${subjid}_rest+tlrc
    meanname=$dir/wmean_mrda${subjid}_rest.nii.gz
    maskname=$dir/mask_wmrda${subjid}_rest+tlrc
    tcname=$dir/swnmrda${subjid}_rest_TCs

    # first thing, make a mask
    if [ ! -f ${maskname+tlrc}.BRIK ]; then
        3dAutomask -prefix ${maskname} ${meanname} 
    fi

    # get all of the timecourses
    for (( i=0; i<10; i++ ))
    do
        if [ ! -f ${tcname}_${i}.1D ]; then
            echo "1deval -a ${tcname}.1D\'[${i}]\' -expr 'a' > ${tcname}_${i}.1D"
            1deval -a ${tcname}.1D\'[${i}]\' -expr 'a' > ${tcname}_${i}.1D
        else
            echo "TC file for $i already created"
        fi

        if [ ! -f ${prefix}_model_${i}+tlrc.BRIK.gz ]; then
            3dsvm -type regression -c 100 -e 0.001 \
                  -trainvol ${dataname} \
                  -trainlabels ${tcname}_${i}.1D \
                  -mask ${maskname} \
                  -model ${prefix}_model_${i} \
                  -bucket ${prefix}_w_${i}
        else
            echo "Model file for $i already created"
        fi

        # now do the predictions
        for file in `find ${PWD}/../ -iname 'swnmrda*rest+tlrc.HEAD' -print`
        do
             ff=`basename ${file}`
             ff=${ff##swnmrda}
             ff=${ff%%_rest+tlrc.HEAD}
             file=${file%%.HEAD}
#
             echo "${file} - > ${ff}" 
             if [ ! -f ${prefix}_pred_${ff}_${i}.1D.1D ]; then
                 3dsvm -testvol ${file} \
                       -model ${prefix}_model_${i}+tlrc \
                       -predictions ${prefix}_pred_${ff}_${i}.1D
             else
                 echo "Prediction file for $ff, $i already created"
             fi
        done
        gzip *model*.BRIK
        gzip *w*.BRIK
    done
done
