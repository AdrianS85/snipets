ls raw_depacked/*fastq > input &&
cat input | sed 's/\.fastq/_short\.fastq/' > output &&
cat output | sed 's/raw_depacked/raw_short/' > output2 &&
mkdir raw_short &&
parallel --link "head -n 40000 {1} > {2}" :::: input :::: output2
