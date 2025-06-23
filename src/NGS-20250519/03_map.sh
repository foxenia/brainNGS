FQ=../../data/NGS-20250519/01.RawData
REF=../../ref/h38_e110_new/genome_new
OUT=../../mapped/NGS-20250519

# Получаем список всех VLxx папок (basename)
sample_ids=$(find "$FQ" -maxdepth 1 -type d -name "VL*" -exec basename {} \;)

for id in $sample_ids; do
    echo "▶️ Обрабатываю: $id"
    mkdir -p "$OUT/$id"

    R1=$(find "$FQ/$id" -name "*_1.fq.gz" | head -n 1)
    R2=$(find "$FQ/$id" -name "*_2.fq.gz" | head -n 1)

    if [[ -f "$R1" && -f "$R2" ]]; then
        STAR --runThreadN 8 --genomeDir "$REF" \
            --readFilesIn "$R1" "$R2" \
            --readFilesCommand zcat \
            --outFilterType BySJout \
            --outFilterMultimapNmax 20 \
            --alignSJoverhangMin 8 \
            --alignSJDBoverhangMin 1 \
            --outFilterMismatchNmax 999 \
            --outFilterMismatchNoverLmax 0.6 \
            --alignIntronMin 20 \
            --alignIntronMax 1000000 \
            --alignMatesGapMax 1000000 \
            --outSAMattributes NH HI NM MD \
            --outSAMtype BAM SortedByCoordinate \
            --outFileNamePrefix "$OUT/$id/" \
            2> "$OUT/$id/log.txt"
    else
        echo "❌ Пропущен $id: не найден R1 или R2"
    fi
done
