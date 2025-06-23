FQ=data/trimmed_bbduk_gut
REF=ref/h38_e110_new/genome


for id in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24
do
	echo id
	mkdir -p mapped/gut/$id
	STAR --runThreadN 8 --genomeDir $REF \
		--readFilesIn ${FQ}/${id}_S${id}_R1_001_trimmed.fastq.gz --outFilterType BySJout \
		--outFilterMultimapNmax 20 --alignSJoverhangMin 8 \
		--alignSJDBoverhangMin 1 --outFilterMismatchNmax 999 \
		--outFilterMismatchNoverLmax 0.6 --alignIntronMin 20 \
		--alignIntronMax 1000000 --alignMatesGapMax 1000000 \
		--outSAMattributes NH HI NM MD --outSAMtype BAM SortedByCoordinate \
		--outFileNamePrefix mapped/gut/$id/ \
		--readFilesCommand zcat 2> mapped/gut/$id/log.txt
done

