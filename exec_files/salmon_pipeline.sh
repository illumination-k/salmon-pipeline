#!/bin/bash

# $1: ref fasta
make_salmon_index() {
    if [ ! -d ./ref ]; then
        echo "there is no salmon index..."
        salmon -t $1 -i ref
    else
        echo "salmon index detected..."
    fi
}

# $1 input fastq $2 threads
single_end_pipeline() {
    basename=${1%.fastq.gz}
    fastp -i $1 -o ${basename}_trim.fastq.gz -w $2 -h ${basename}.html -j ${basename}.json
    salmon quant -i ./ref -p $2 -l A -r ${basename}_trim.fastq.gz -o ${basename}_exp --gcBias --validateMappings
}

# $1 read1 fastq $2 read2 fastq $3 thread
pair_end_pipeline() {
    basename=${1%_1.fastq.gz}
    fastp -i $1 -I $2 -o ${basename}_1_trim.fastq.gz -O ${basename}_2_trim.fastq.gz -w $3 -h ${basename}.html -j ${basename}.json
    salmon quant -i ./ref -p $3 -l A -1 ${basename}_1_trim.fastq.gz -2 ${basename}_2_trim.fastq.gz -o ${basename}_exp --gcBias --validateMappings
}

# $1 inputpath $2 method
quant() {
    Rscript /workspace/quant2csv.R $1 $2
    multiqc $1
}

path=$1
mode=$2
scale_methods=$3
threads=$4

cd $path

if [ $mode = "single" ]; then
    echo "single end mode"
    for f in $(ls *.fastq.gz); do
        single_end_pipeline $f $threads
    done

    quant . $scale_methods
elif [ $mode = "pair" ]; then
    echo "pair end mode"
    for f1 in $(ls *_1.fastq.gz); do
        f2=${f1%_1.fastq.gz}_2.fastq.gz
        pair_end_pipeline $f1 $f2 $threads
    done
    quant . $scale_methods
else
    echo "mode must be pair or single"
fi
