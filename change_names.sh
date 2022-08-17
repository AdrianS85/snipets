# -s : bash-compatible expression for selecting files to change name of # SRR*
# -f : change string from this (regex)
# -t : to this
# -d : directory in which files are present. If left alone - current folder # not implemented
# -o : output directory # not implemented
# bash make_short_files.sh -b RNA_S5227Nr -f fq -g true -n 100000



while getopts "s:f:t:" flag
do
        case ${flag} in
                s) selector=$OPTARG;;
                f) from=$OPTARG;;
                t) to=$OPTARG;;
        esac
done

ls ${selector} | tee original_names.temp
cat original_names.temp | sed "s/${from}/${to}/" | tee changed_names.temp
paste original_names.temp changed_names.temp | tee both_names.temp
parallel --colsep '\t' "mv {1} {2}" :::: both_names.temp
rm original_names.temp changed_names.temp
