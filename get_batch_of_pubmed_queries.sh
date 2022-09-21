# bash get_abstract.sh  -i ../12up_enrich.txt -g "autophagy" -d output
# probably should check for temp name, but who cares

while getopts "i:g:d:" flag
do
        case ${flag} in
                i) input=$OPTARG;; # list of queries, single query per line
                g) general=$OPTARG;; # a general term to be added to each query
		d) directory=$OPTARG;; # output directory
        esac
done



mkdir ${directory}

sed -e "s/$/ ${general}/" ${input} > combined_query.temp

cat combined_query.temp | while read query 
do
   echo ${query}

   esearch -db pubmed -query "${query}" < /dev/null  | efetch -format abstract -mode text > "${directory}/${query}.txt"

   if [ ! -s "${directory}/${query}.txt" ]
   then
        rm "${directory}/${query}.txt"
   fi

   sleep 0.34
done

rm combined_query.temp
