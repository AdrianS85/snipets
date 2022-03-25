# -f : format. Are files gziped. f for fastq, g for fastq.gz ###!!! NOT fq! something to update if needed further
# -p : should files be gziped after shortening
# -d : directory in which files are present. If left alone - current folder
# -o : output directory
# -r : reference file in format - 2 columns, first column with original names, second with changed name. output of get_old_and_updated_file_names.py
# -s : separator used in reference file either t for tab or c for comma
# -n : how many netries do You want
# bash test.sh -r old_and_updated_file_names.tsv

format=g
inputdir=$(pwd)
outputdir=$(pwd)
sep=t
number=100000

while getopts f:pr:d:o:s: flag
do
	case "${flag}" in
		f) format=$OPTARG;;
		p) tobezipped=false;;
		r) reference=$OPTARG;;
		d) inputdir=$OPTARG;;
		o) outputdir=$OPTARG;;
		s) sep==$OPTARG;;
		n) number=$OPTARG;;
	esac
done



tempdir=$(echo "${inputdir}/make_short_files_script_temp")

if [[ ! -e $tempdir ]]; then
	mkdir $tempdir
	mkdir ${tempdir}/pre_ass
	mkdir ${tempdir}/ass
	mkdir ${tempdir}/ass2
	mkdir ${tempdir}/ass3
fi

number=$((number*4))



cp ${reference} ${tempdir}/pre_ass
awk '{print $2}' ${tempdir}/pre_ass > ${tempdir}/ass
cp ${tempdir}/ass ${tempdir}/ass2
sed -i s/.fastq.gz/.fastq/g ${tempdir}/ass
sed -i s/.fastq.gz/_small.fastq/g ${tempdir}/ass2
paste ${tempdir}/ass ${tempdir}/ass2 > ${tempdir}/ass3




if [ ${format} = g ]
then
	filestodo=$(ls $(echo "${inputdir}/*.fastq.gz"))

	if [ ${sep} = t ]; then
		parallel --colsep '\t' "cp {1} ${tempdir}/{2}; gzip -d ${tempdir}/{2}" :::: $reference
	elif [ ${sep} = c ]; then
		parallel "cp {1} ${tempdir}/{2}; gzip -d ${tempdir}/{2}" :::: $reference
	fi
	
	parallel --colsep '\t' "head -n ${number} ${tempdir}/{1} > ${outputdir}/{2}" :::: ${tempdir}/ass3
	
elif [ ${format} = f ]
then
	filestodo=$(ls $(echo "${inputdir}/*.fastq"))

	if [ ${sep} = t ]; then
		echo "Not implemented, bub"
	elif [ ${sep} = c ]; then
		echo "Not implemented, bub"
	fi
fi

rm -R ${tempdir}
