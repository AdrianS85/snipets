ls raw_short/*fastq > input &&

mkdir fastqc_folder &&

parallel "fastqc --outdir=./fastqc_folder" :::: input && 

cd fastqc_folder &&

multiqc . &&

cd ..
