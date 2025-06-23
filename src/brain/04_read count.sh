# multiqc
conda activate NGS
multiqc -o output/brain mapped

#htseq
conda deactivate //NGS env
conda activate htseq

# index bam files

for dir in VL1 VL2 VL3 VL4 VL5 VL6 VL7 VL7 VL8
do
    bamfile="$dir/Aligned.sortedByCoord.out.bam"  # Путь к BAM-файлу
    index=$(basename "$dir")                     # Извлекаем имя папки (например, VL1)
    samtools index "$bamfile" "${dir}/Aligned.${index}.bai"  # Создаем индекс с указанием папки
done

#Count reads per gene
# at the beginning, we started without "&", but it took quite long, so we start it in parallel (8 samples-8 cores). For more samples, not recommended.

for sid in `ls -1 mapped/`
do
 echo $sid 
 htseq-count \
  -m intersection-nonempty \
  -s yes \
  -f bam \
  -r pos \
  mapped/$sid/Aligned.sortedByCoord.out.bam \
  ref/h38_e110_new/genes.gtf \
  > output/counts/${sid}.tsv& 
done 