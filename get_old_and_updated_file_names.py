from argparse import ArgumentParser
from re import compile, sub
from os import getcwd, listdir
### sudo python get_old_and_updated_file_names.py --reFileSearch ".*1\.fastq\.gz" --reReplace "1\.fastq\.gz" --toReplace "R1.fq.gz"
### parallel --verbose --joblog jolog.txt --jobs 4 --colsep "\t" "mv {1} {2}" :::: old_and_updated_file_names.tsv




if __name__ == '__main__':
    parser = ArgumentParser(description='Returns a file with current and updated filenames for files of interest')
    parser.add_argument('--dir', default=getcwd(), help='Directory in which files are present. If left alone - current folder')
    parser.add_argument('--outName', default='old_and_updated_file_names.tsv', help='Output file name')
    parser.add_argument('--reFileSearch', help='Regex. Searches for files of interest')
    parser.add_argument('--reReplace', help='Regex. Replace this...')
    parser.add_argument('--toReplace', help='... with this')
    args = parser.parse_args()

    arguments_ = {
        'dir': args.dir,
        'outName': args.outName,
        'reFileSearch': args.reFileSearch,
        'reReplace': args.reReplace,
        'toReplace': args.toReplace
    }



    fileList = listdir(arguments_['dir'])

    r = compile(arguments_['reFileSearch'])
    fileListUpdated = list(filter(r.match, fileList))

    fileListUpdatedNewNames = list(map(lambda stringr_: sub(arguments_['reReplace'], arguments_['toReplace'], stringr_), fileListUpdated))

    with open(arguments_['outName'], 'w') as f:
        for element in range(len(fileListUpdated)): 
            f.write(fileListUpdated[element] + '\t' + fileListUpdatedNewNames[element] + '\n')
