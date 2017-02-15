## MiCE 5992 Tutorial: QIIME Core diversity analyses

### Background
In this tutorial we will learn how to run all standard QIIME analyses including alpha diversity, beta diversity, and significance testing.
We will use a QIIME parameters file to tweak the settings.

### Setup
1. Connect to MSI  
 Follow the steps in the [Getting Started Guide](../../README.md) to connect to MSI using SSH.

 When you first log in, you will be on the "login" node. You are not allowed to run computations on this node. Instead, you can get to an interactive node for running computations with this command:
 ```bash
    isub -n nodes=1:ppn=4 -m 8GB -w 02:00:00
 ```
 Note: if you ever receive an error saying that you have exceeded the available memory, you can increase to 16GB.
 You can also request 8 hours instead of two as follows:
 ```bash
    isub -n nodes=1:ppn=4 -m 16GB -w 08:00:00
 ```
2. Load software  
 Load all of the software "modules" that you will need.
 ```bash
    module load qiime/1.9.1
    module load bowtie2
 ```

3. Go to the tutorial directory
 Change to your personal course directory if you are not already there:
 ```bash
    /home/mice5992/<yourusername>
 ```

 List the contents of your home directory:
 ```bash
    ls
 ```

 Then change directories into the course repository folder that you downloaded:
 ```bash
    cd mice5992-2017
 ```

4. Update the directory 
 The following command will "pull" (download) any updates to the online repository to your local filesystem on MSI:
 ```bash
    git pull
 ```

 Then change directories into the new tutorial folder:
 ```bash
    cd tutorials
    cd corediv
 ```

 List the contents of the directory:
 ```bash
    ls
 ```
 You should see a file `parameters.txt`.

4. Pick Operational Taxonomic Units (OTUs) again
 Find the closest match for each sequence in a reference database using NINJA-OPS.

 ```bash
    time python /home/mice5992/shared/NINJA-OPS-1.5.1/bin/ninja.py -i ../../data/globalgut/seqs.fna -o otus -p 4 -z
    ls otus
 ```
 Note that we added `-z`. What does this do? Run the same command with `-h` to find out.
 
 Get a nice summary of the OTU table, and inspect the first 20 lines using `head`:
 ```bash
    biom summarize_table -i otus/ninja_otutable.biom -o otus/stats.txt
    head -n 20 otus/stats.txt
 ```
 
 From this summary you should be able to answer these questions:
  - How many unique OTUs (taxonomic groups) are there?
  - How many samples?
  - How many total sequences matched the database overall?
  - How many sequences matched the database in the lowest coverage sample?

 To view more of this file, you can scroll up and down inside it with `less otus/stats.txt`.
 However, you will need to quit `less` by typing `q` before you do anything else.
 
5. Run alpha diversity analysis and make plots of rarefaction curves.

 ```bash
    alpha_rarefaction.py -i otus/ninja_otutable_s10.biom --min_rare_depth 100 --max_rare_depth 500 --num_steps 3 -o alpha_rare -m ../../data/globalgut/map.txt -v -p parameters.txt -t /home/mice5992/shared/97_otus.tree
 ```

6. Make taxonomy stacked bar plots

 ```bash
    summarize_taxa_through_plots.py -i otus/ninja_otutable_s10.biom -p parameters.txt -w -o taxaplots/
 ```

7. Run all other core QIIME diversity analyses, suppressing the alpha diversity and taxonomy plots.
 Note: we could run all of the analyses here, but it would take a long time. We ran the `alpha_rarefaction.py` 
 and `summarize_taxa_through_plots.py` separately because QIIME's `core_diversity_analyses.py` script does not properly use the 
 parameters file for running these. By running them separately we are able to tweak the settings and make them run faster.

 ```bash
    time core_diversity_analyses.py -i otus/ninja_otutable_s10.biom -m ../../data/globalgut/map.txt -c "AGE_GROUP,COUNTRY" -o corediv -e 500 --tree_fp /home/mice5992/shared/97_otus.tree --suppress_alpha_diversity --suppress_taxa_summary -v
 ```

8. Move the files back from MSI to your computer using Filezilla  
 See instructions on [Getting Started Guide](../../README.md) to connect to MSI using Filezilla. Navigate to `/home/mice5992/yourusername/mice5992-2017/tutorials/qiime/`. Drag the `corediv`, `taxaplots`, and `alpha_rare` folders to your computer.
 
9. Repeat using other data  
 Choose one of the many studies with sequence files and mapping files in this directory:
 ```bash
    ls /home/knightsd/public/qiime_db/processed/
    ls /home/knightsd/public/qiime_db/processed/Bushman_enterotypes_cafe_study_1010_ref_13_8
 ```

 Before running all of these analyses, use Filezilla/FTP to move the mapping file over to your computer, and view this using Excel (or Google Sheets). 
 Can you find a category that is interesting to run comparisons against? Use this information when running core diversity analyses on that file.
 ```bash
    mkdir bonus
    cd bonus
 ```

 Then on MSI make a new directory to work in and move into it:
 ```bash
    mkdir bonus
    cd bonus
 ```
 
  Now run OTU picking, and the core diversity analyses above:
 ```bash
    python /home/mice5992/shared/NINJA-OPS-1.5.1/bin/ninja.py -i /home/knightsd/public/qiime_db/processed/Bushman_enterotypes_cafe_study_1010_ref_13_8/Bushman_enterotypes_cafe_study_1010_split_library_seqs.fna -o otus -p 4
    
    etc.
 ```

10. 
