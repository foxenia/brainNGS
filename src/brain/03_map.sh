FQ=data/trimmed_bbduk_brain
REF=ref/h38_e110_new/genome_new


for id in 1 2 3 4 5 6 7 8
do
	echo id
	mkdir mapped/brain/VL$id
	STAR --runThreadN 8 --genomeDir $REF \
		--readFilesIn ${FQ}/VL${id}_S${id}_R1_001_trimmed.fastq.gz,${FQ}/VL${id}_S${id}r_R1_001_trimmed.fastq.gz --outFilterType BySJout \
		--outFilterMultimapNmax 20 --alignSJoverhangMin 8 \
		--alignSJDBoverhangMin 1 --outFilterMismatchNmax 999 \
		--outFilterMismatchNoverLmax 0.6 --alignIntronMin 20 \
		--alignIntronMax 1000000 --alignMatesGapMax 1000000 \
		--outSAMattributes NH HI NM MD --outSAMtype BAM SortedByCoordinate \
		--outFileNamePrefix mapped/brain/VL$id/ \
		--readFilesCommand zcat 2>mapped/brain/VL$id/log.txt
done

