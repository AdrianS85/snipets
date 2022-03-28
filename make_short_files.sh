# -b : basal name of fastq files. This means all that is common for all fastq files that we want to shorten ### !!! should change default from none to not present and check this in an if
# -f : format. fastq or fq. default fq
# -g : Are files gziped. default = true
# -d : directory in which files are present. If left alone - current folder
# -o : output directory
# -n : how many netries do You want
# bash test.sh -r old_and_updated_file_names.tsv
### dobra, jak daje wiecej opcji niż -r to się wszystko wywala, nie wiem o co chodzi, jak kiedyś coś to mogę naprawić.
# bash make_short_files.sh -b RNA_S5227Nr -f fq -g true -n 100000




basalname=none
format=fq
inputdir=$(pwd)
outputdir=$(pwd)
number=100000



while getopts b:f:gd:o:n: flag
do
	case "${flag}" in
		b) basalname=$OPTARG;;
		f) format=$OPTARG;;
		g) gziped=true;;
		d) inputdir=$OPTARG;;
		o) outputdir=$OPTARG;;
		n) number=$OPTARG;;
	esac
done



if [[ ${basalname} == none ]]; then
        echo 'Missing -b' >&2
        exit 1
fi

if [[ ${format} != fq ]] && [[ ${format} != fastq ]]; then
        echo '-f needs to equal fq or fastq' >&2
        exit 1
fi



tempdir=$(echo "${inputdir}/make_short_files_script_temp")

if [[ ! -e $tempdir ]]; then
	mkdir $tempdir
fi

number=$((number*4))



ls -d *${basalname}* | tee ${tempdir}/files_to_shorten &&
cp ${tempdir}/files_to_shorten ${tempdir}/files_to_shorten_unpacked &&
sed -i s/.gz$//g ${tempdir}/files_to_shorten_unpacked &&
cp ${tempdir}/files_to_shorten_unpacked ${tempdir}/output_names &&
sed -i s/"$basalname"/short_"$basalname"/g ${tempdir}/output_names &&
paste ${tempdir}/files_to_shorten ${tempdir}/files_to_shorten_unpacked ${tempdir}/output_names > ${tempdir}/all_names



if [ ${gziped} == true ]
then
	parallel --colsep '\t' "cp {1} ${tempdir}/{1} && gzip -d ${tempdir}/{1} && head -n ${number} ${tempdir}/{2} > ${outputdir}/{3} && rm ${tempdir}/{2} && gzip ${outputdir}/{3} " :::: ${tempdir}/all_names
	
elif [ ${gziped} == false ]
then
	parallel --colsep '\t' "cp {1} ${tempdir}/{1} && head -n ${number} ${tempdir}/{1} > ${outputdir}/{3} && rm ${tempdir}/{1} && gzip ${outputdir}/{3} " :::: ${tempdir}/all_names
fi

rm -R ${tempdir}
