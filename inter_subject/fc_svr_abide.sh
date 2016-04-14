argc=$#
argv=("$@")

mask="/data2/abide/mask/cc200_binary.nii.gz"
inv_mask="/data2/abide/mask/invert"

subdirs=( '/data2/abide/data/NYU_0050952' \
          '/data2/abide/data/NYU_0050954' \
          '/data2/abide/data/NYU_0050955' \
          '/data2/abide/data/NYU_0050956' \
          '/data2/abide/data/NYU_0050957' \
          '/data2/abide/data/NYU_0050958' \
          '/data2/abide/data/NYU_0050959' \
          '/data2/abide/data/NYU_0050960' \
          '/data2/abide/data/NYU_0050961' \
          '/data2/abide/data/NYU_0050962' \
          '/data2/abide/data/NYU_0050964' \
          '/data2/abide/data/NYU_0050965' \
          '/data2/abide/data/NYU_0050966' \
          '/data2/abide/data/NYU_0050967' \
          '/data2/abide/data/NYU_0050968' \
          '/data2/abide/data/NYU_0050969' \
          '/data2/abide/data/NYU_0050970' \
          '/data2/abide/data/NYU_0050972' \
          '/data2/abide/data/NYU_0050973' \
          '/data2/abide/data/NYU_0050974' \
          '/data2/abide/data/NYU_0050976' \
          '/data2/abide/data/NYU_0050977' \
          '/data2/abide/data/NYU_0050978' \
          '/data2/abide/data/NYU_0050979' \
          '/data2/abide/data/NYU_0050981' \
          '/data2/abide/data/NYU_0050982' \
          '/data2/abide/data/NYU_0050983' \
          '/data2/abide/data/NYU_0050984' \
          '/data2/abide/data/NYU_0050985' \
          '/data2/abide/data/NYU_0050986' \
          '/data2/abide/data/NYU_0050987' \
          '/data2/abide/data/NYU_0050988' \
          '/data2/abide/data/NYU_0050989' \
          '/data2/abide/data/NYU_0050990' \
          '/data2/abide/data/NYU_0050991' \
          '/data2/abide/data/NYU_0050992' \
          '/data2/abide/data/NYU_0050993' \
          '/data2/abide/data/NYU_0050994' \
          '/data2/abide/data/NYU_0050995' \
          '/data2/abide/data/NYU_0050996' \
          '/data2/abide/data/NYU_0050997' \
          '/data2/abide/data/NYU_0050998' \
          '/data2/abide/data/NYU_0050999' \
          '/data2/abide/data/NYU_0051000' \
          '/data2/abide/data/NYU_0051001' \
          '/data2/abide/data/NYU_0051002' \
          '/data2/abide/data/NYU_0051003' \
          '/data2/abide/data/NYU_0051006' \
          '/data2/abide/data/NYU_0051007' \
          '/data2/abide/data/NYU_0051008' \
          '/data2/abide/data/NYU_0051009' \
          '/data2/abide/data/NYU_0051010' \
          '/data2/abide/data/NYU_0051011' \
          '/data2/abide/data/NYU_0051012' \
          '/data2/abide/data/NYU_0051013' \
          '/data2/abide/data/NYU_0051014' \
          '/data2/abide/data/NYU_0051015' \
          '/data2/abide/data/NYU_0051016' \
          '/data2/abide/data/NYU_0051017' \
          '/data2/abide/data/NYU_0051018' \
          '/data2/abide/data/NYU_0051019' \
          '/data2/abide/data/NYU_0051020' \
          '/data2/abide/data/NYU_0051021' \
          '/data2/abide/data/NYU_0051023' \
          '/data2/abide/data/NYU_0051024' \
          '/data2/abide/data/NYU_0051025' \
          '/data2/abide/data/NYU_0051026' \
          '/data2/abide/data/NYU_0051027' \
          '/data2/abide/data/NYU_0051028' \
          '/data2/abide/data/NYU_0051029' \
          '/data2/abide/data/NYU_0051030' \
          '/data2/abide/data/NYU_0051032' \
          '/data2/abide/data/NYU_0051033' \
          '/data2/abide/data/NYU_0051034' \
          '/data2/abide/data/NYU_0051035' \
          '/data2/abide/data/NYU_0051036' \
          '/data2/abide/data/NYU_0051038' \
          '/data2/abide/data/NYU_0051039' \
          '/data2/abide/data/NYU_0051040' \
          '/data2/abide/data/NYU_0051041' \
          '/data2/abide/data/NYU_0051042' \
          '/data2/abide/data/NYU_0051044' \
          '/data2/abide/data/NYU_0051045' \
          '/data2/abide/data/NYU_0051046' \
          '/data2/abide/data/NYU_0051047' \
          '/data2/abide/data/NYU_0051048' \
          '/data2/abide/data/NYU_0051049' \
          '/data2/abide/data/NYU_0051050' \
          '/data2/abide/data/NYU_0051051' \
          '/data2/abide/data/NYU_0051052' \
          '/data2/abide/data/NYU_0051053' \
          '/data2/abide/data/NYU_0051054' \
          '/data2/abide/data/NYU_0051055' \
          '/data2/abide/data/NYU_0051056' \
          '/data2/abide/data/NYU_0051057' \
          '/data2/abide/data/NYU_0051058' \
          '/data2/abide/data/NYU_0051059' \
          '/data2/abide/data/NYU_0051060' \
          '/data2/abide/data/NYU_0051061' \
          '/data2/abide/data/NYU_0051062' \
          '/data2/abide/data/NYU_0051063' \
          '/data2/abide/data/NYU_0051064' \
          '/data2/abide/data/NYU_0051065' \
          '/data2/abide/data/NYU_0051066' \
          '/data2/abide/data/NYU_0051067' \
          '/data2/abide/data/NYU_0051068' \
          '/data2/abide/data/NYU_0051069' \
          '/data2/abide/data/NYU_0051070' \
          '/data2/abide/data/NYU_0051071' \
          '/data2/abide/data/NYU_0051072' \
          '/data2/abide/data/NYU_0051073' \
          '/data2/abide/data/NYU_0051074' \
          '/data2/abide/data/NYU_0051075' \
          '/data2/abide/data/NYU_0051076' \
          '/data2/abide/data/NYU_0051077' \
          '/data2/abide/data/NYU_0051078' \
          '/data2/abide/data/NYU_0051079' \
          '/data2/abide/data/NYU_0051080' \
          '/data2/abide/data/NYU_0051081' \
          '/data2/abide/data/NYU_0051082' \
          '/data2/abide/data/NYU_0051083' \
          '/data2/abide/data/NYU_0051084' \
          '/data2/abide/data/NYU_0051085' \
          '/data2/abide/data/NYU_0051086' \
          '/data2/abide/data/NYU_0051087' \
          '/data2/abide/data/NYU_0051088' \
          '/data2/abide/data/NYU_0051089' \
          '/data2/abide/data/NYU_0051090' \
          '/data2/abide/data/NYU_0051091' \
          '/data2/abide/data/NYU_0051093' \
          '/data2/abide/data/NYU_0051094' \
          '/data2/abide/data/NYU_0051095' \
          '/data2/abide/data/NYU_0051096' \
          '/data2/abide/data/NYU_0051097' \
          '/data2/abide/data/NYU_0051098' \
          '/data2/abide/data/NYU_0051099' \
          '/data2/abide/data/NYU_0051100' \
          '/data2/abide/data/NYU_0051101' \
          '/data2/abide/data/NYU_0051102' \
          '/data2/abide/data/NYU_0051103' \
          '/data2/abide/data/NYU_0051104' \
          '/data2/abide/data/NYU_0051105' \
          '/data2/abide/data/NYU_0051106' \
          '/data2/abide/data/NYU_0051107' \
          '/data2/abide/data/NYU_0051109' \
          '/data2/abide/data/NYU_0051110' \
          '/data2/abide/data/NYU_0051111' \
          '/data2/abide/data/NYU_0051112' \
          '/data2/abide/data/NYU_0051113' \
          '/data2/abide/data/NYU_0051114' \
          '/data2/abide/data/NYU_0051116' \
          '/data2/abide/data/NYU_0051117' \
          '/data2/abide/data/NYU_0051118' \
          '/data2/abide/data/NYU_0051121' \
          '/data2/abide/data/NYU_0051122' \
          '/data2/abide/data/NYU_0051123' \
          '/data2/abide/data/NYU_0051124' \
          '/data2/abide/data/NYU_0051126' \
          '/data2/abide/data/NYU_0051127' \
          '/data2/abide/data/NYU_0051128' \
          '/data2/abide/data/NYU_0051129' \
          '/data2/abide/data/NYU_0051130' \
          '/data2/abide/data/NYU_0051131' \
          '/data2/abide/data/NYU_0051146' \
          '/data2/abide/data/NYU_0051147' \
          '/data2/abide/data/NYU_0051148' \
          '/data2/abide/data/NYU_0051149' \
          '/data2/abide/data/NYU_0051150' \
          '/data2/abide/data/NYU_0051151' \
          '/data2/abide/data/NYU_0051152' \
          '/data2/abide/data/NYU_0051153' \
          '/data2/abide/data/NYU_0051154' \
          '/data2/abide/data/NYU_0051155' \
          '/data2/abide/data/NYU_0051156' \
          '/data2/abide/data/NYU_0051159' )


export AFNI_COMPRESS=GZIP
export AFNI_PATH=/home/cfroehlich/afni_bin

if [ "$argc" -ne "1" ]
then
    echo "usage: ${argv[0]} <subnum>"
    exit 1
fi

subnum=${argv[0]}
dir=${subdirs[${subnum}]}
echo "Processing ${subnum} ${dir} ${subid}"

ccwd=$PWD

# verify that the file exists, is appropriate, and parse out 
# relevant information
if [ ! -d ${dir} ]
then
    echo "$dir does not exist" 
    exit 1
fi

# go into the directory to make some things easier
cd $dir

subid=$( basename $dir )

prefix=${subid}
dataname=${subid}_sm_zscore.nii.gz
tcname=${subid}_label

echo "Processing ${subnum} ${dir} ${subid}"

# get all of the timecourses
#for (( i=1; i<201; i++ ))
for (( i=1; i<2; i++ ))
do

    if [ ! -f ${tcname}_${i}.1D ]
    then
        echo "Couldn't find TC file for ${i} (${tcname}_${i}.1D)"
        continue
    fi

	if [ ! -f ${prefix}_w_${i}.nii.gz ]
	then
		${AFNI_PATH}/3dsvm -type regression -c 100 -e 0.001 \
		  -trainvol ${dataname} \
		  -trainlabels ${tcname}_${i}.1D \
		  -mask ${inv_mask}_${i}.nii.gz \
		  -model ${prefix}_model_${i}.nii.gz \
		  -bucket ${prefix}_w_${i}.nii.gz

        rm ${prefix}_model_${i}.nii.gz
	else
		echo "Model file for $i already created"
	fi

    pred_dir=${PWD}/pred_${i}
    if [ ! -d ${pred_dir} ]
    then
        mkdir -p ${pred_dir}
    fi

 
	# now do the predictions
    for (( s=1; s<${#subdirs[@]}; s++ ))
    do
        echo "$s <=> $subnum"
        if [ "${s}" -ne "${subnum}" ]
        then
            testsub=$( basename ${subdirs[${s}]} )
            testdata=${subdirs[${s}]}/${testsub}_sm_zscore.nii.gz

            pred_file=${pred_dir}/${subid}_${testsub}_pred_${i}.1D

            echo "predicting ${testsub} ${i}" 

            ${AFNI_PATH}/3dsvm_linpredict -mask ${mask} \
                ${prefix}_w_${i}.nii.gz \
                ${testdata} \
                > ${pred_file}
		 fi
	done
done
