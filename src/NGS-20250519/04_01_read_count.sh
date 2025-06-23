#!/bin/bash

REF="/mnt/data4A/ksenia/projects/brainNGS/ref/h38_e110_new/genes_new.gtf"
MAPPED="/mnt/data4A/ksenia/projects/brainNGS/mapped/NGS-20250519"
OUTPUT="/mnt/data4A/ksenia/projects/brainNGS/output/NGS-20250519/counts"

ls -1 "$MAPPED" | parallel -j 8 '
  echo "Processing {}"
  htseq-count \
    -m intersection-nonempty \
    -s no \
    -f bam \
    -r pos \
    '"$MAPPED"'/{}/Aligned.sortedByCoord.out.bam \
    '"$REF"' \
    > '"$OUTPUT"'/{}.tsv
'
