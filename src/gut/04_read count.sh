# multiqc
conda activate NGS
multiqc -o output/gut mapped/gut



#htseq
conda deactivate #NGS env
conda activate htseq

# index bam files - not obligatory
for dir in `ls -1 mapped/gut`
do
    echo $dir
    bamfile="mapped/gut/$dir/Aligned.sortedByCoord.out.bam"  # Путь к BAM-файл
    samtools index -@ 8 $bamfile # Создаем индекс с указанием папки
done

#Count reads per gene
# -j8 tells to run not more than 8 instances simultaneously
# {} is replaced with output of ls -1 (sample name)
ls -1 mapped/gut | parallel -j8 "htseq-count \
  -m intersection-nonempty \
  -s yes \
  -f bam \
  -r pos \
  mapped/gut/{}/Aligned.sortedByCoord.out.bam \
  ref/h38_e110_new/genes.gtf \
  > output/gut/counts/{}.tsv" 