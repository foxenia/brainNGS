cd ref/h38_e110
wget https://ftp.ensembl.org/pub/release-110/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
wget https://ftp.ensembl.org/pub/release-110/gtf/homo_sapiens/Homo_sapiens.GRCh38.110.gtf.gz
#astrovirus VA1 from https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000885815.1/
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/885/815/GCF_000885815.1_ViralProj39811/GCF_000885815.1_ViralProj39811_genomic.fna.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/885/815/GCF_000885815.1_ViralProj39811/GCF_000885815.1_ViralProj39811_genomic.gtf.gz
#astrovirus MLB2 from https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000895575.1/
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/895/575/GCF_000895575.1_ViralProj76723/GCF_000895575.1_ViralProj76723_genomic.fna.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/895/575/GCF_000895575.1_ViralProj76723/GCF_000895575.1_ViralProj76723_genomic.gtf.gz
#astrovirus HAst4 from https://www.ncbi.nlm.nih.gov/datasets/genome/GCA_031106085.1/
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/031/106/085/GCA_031106085.1_ASM3110608v1/GCA_031106085.1_ASM3110608v1_genomic.fna.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/031/106/085/GCA_031106085.1_ASM3110608v1/GCA_031106085.1_ASM3110608v1_genomic.gtf.gz
cat *a.gz > genomes.fa.gz



#unzip virus gtf.gz
gunzip -k G*.gtf.gz
#change manually
#gzip new modified virus annotations (gtf), where we changed CDS to exons.
gzip *mod.gtf
#combine new modified virus gz with the human gz
cat Homo_sapiens.GRCh38.110.gtf.gz *mod.gtf.gz > genes.gtf.gz

# on institute machine home folder is small, create folder on large disk:
sudo mkdir /mnt/data4A/ksenia/
sudo chown ksenia:ksenia /mnt/data4A/ksenia/ # reown it to ksenia
# make softlink in home
ln -s /mnt/data4A/ksenia/ data4A
mkdir genome # when running on institute computer it failed if folderwas not created
STAR \
 --runThreadN 4 \
 --runMode genomeGenerate \
 --genomeDir genome \
 --genomeFastaFiles genomes.fa \
 --sjdbGTFfile genes.gtf \
 --sjdbOverhang 100