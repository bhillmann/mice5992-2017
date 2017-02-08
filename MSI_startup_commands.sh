# log in to interactive node
isub -n nodes=1:ppn=4 -m 8GB -w 02:00:00

# load QIIME and other dependencies
module load qiime/1.9.1
module load bowtie2
