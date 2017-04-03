## MiCE 5992 Tutorial: MCT study

### Background
In this tutorial we will learn how to filter and collapse tables for custom analysis.

### Setup
1. Connect to MSI  
 Follow the steps in the [Getting Started Guide](../../README.md) to connect to MSI using SSH.

 When you first log in, you will be on the "login" node. You are not allowed to run computations on this node. Instead, you can get to an interactive node for running computations with this command:
 ```bash
    isub -n nodes=1:ppn=4 -m 8GB -w 02:00:00
 ```

2. Load software  
 Load all of the software "modules" that you will need.
 ```bash
    module load qiime/1.9.1
 ```

3. Go to the tutorial directory
 Change to your personal course directory if you are not already there:
 ```bash
    /home/mice5992/<yourusername>
 ```

 List the contents of your home directory, if you are curious what's in there:
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
    cd mct-v2
 ```

 List the contents of the directory:
 ```bash
    ls
 ```
 You should see a file `parameters.txt`. Print the contents of this file to the screen with `cat`:
 
 ```bash
    cat parameters.txt
 ```

### Analysis
5. Remove samples with outlier dietary information and subjects, 12, 21, 30 (too few samples)
 The file sample_ids_to_exclude.txt is just a text file with the names of samples to exclude. Print the contents:

 ```bash
    cat sample_ids_to_exclude.txt
 ```
 
 Now remove those samples with `filter_samples_from_otu_table.py`:

 ```bash
    filter_samples_from_otu_table.py -i otutable.biom -o otutable-subset.biom --sample_id_fp sample_ids_to_exclude.txt --negate_sample_id_fp -m new_map_with_treatment.txt --output_mapping_fp map-subset.txt
 ```

6.  For microbiome analysis, Drop samples with < 50,000 sequences, Drop rare OTUs, subsetting by pre/post
 ```bash
    filter_samples_from_otu_table.py -n 50000 -i otutable-subset.biom -o otutable-subset-n50000.biom
    filter_otus_from_otu_table.py -s 10 -i otutable-subset-n50000.biom -o otutable-subset-n50000-s10.biom

    # Subsetting pre/post using QIIME
    filter_samples_from_otu_table.py -i otutable-subset-n50000-s10.biom -o otutable-subset-n50000-s10-pre.biom -m map-subset.txt --output_mapping_fp map-subset-pre.txt -s "Treatment:Pre"
    filter_samples_from_otu_table.py -i otutable-subset-n50000-s10.biom -o otutable-subset-n50000-s10-post.biom -m map-subset.txt --output_mapping_fp map-subset-post.txt -s "Treatment:Post"
 ```

7. Collapse by subject
 ```bash
    # use QIIME to collapse the filtered OTU table and the pre/post filtered otu tables
    collapse_samples.py -b otutable-subset-n50000-s10.biom -m map-subset.txt --output_mapping_fp map-subset-collapse-UserName.txt --output_biom_fp otutable-subset-n50000-s10-collapse-UserName.biom --collapse_mode sum --collapse_fields UserName 
    
    # Same for "Pre" samples
    collapse_samples.py -b otutable-subset-n50000-s10-pre.biom -m map-subset-pre.txt --output_mapping_fp map-subset-pre-collapse-UserName.txt --output_biom_fp otutable-subset-n50000-s10-pre-collapse-UserName.biom --collapse_mode sum --collapse_fields UserName

    # Same for "Post" samples
    collapse_samples.py -b otutable-subset-n50000-s10-post.biom -m map-subset-post.txt --output_mapping_fp map-subset-post-collapse-UserName.txt --output_biom_fp otutable-subset-n50000-s10-post-collapse-UserName.biom --collapse_mode sum --collapse_fields UserName

    # Use custom R script to collapse the full mapping files by subject. QIIME doesn't do this well so we use R.
    Rscript collapse_map.r map-subset.txt UserName map-subset-collapse-UserName.txt
    Rscript collapse_map.r map-subset-pre.txt UserName map-subset-pre-collapse-UserName.txt
    Rscript collapse_map.r map-subset-post.txt UserName map-subset-post-collapse-UserName.txt

 ```

8. Continue with downstream analysis (taxonomy, beta diversity, etc.) using these files:
 - Longitudinal data
   - Full study
     - Mapping file: `map-subset.txt`
     - OTU table: `otutable-subset-n50000-s10.biom`
   - Pre-treatment samples
     - Mapping file: `map-subset-pre.txt`
     - OTU table: `otutable-subset-n50000-s10-pre.biom`
   - Post-treatment samples
     - Mapping file: `map-subset-post.txt`
     - OTU table: `otutable-subset-n50000-s10-post.biom`
 - Collapsed by Subject
   - Full study
     - Mapping file: `map-subset-collapse-UserName.txt`
     - OTU table: `otutable-subset-n50000-s10-collapse-UserName.biom`
   - Pre-treatment samples
     - Mapping file: `map-subset-pre.txt`
     - OTU table: `otutable-subset-n50000-s10-pre-collapse-UserName.biom`
   - Post-treatment samples
     - Mapping file: `map-subset-post.txt`
     - OTU table: `otutable-subset-n50000-s10-post-collapse-UserName.biom`
 - Raw data
    - Mapping file: `new_map_with_treatment.txt`
    - Full OTU table: `otutable.biom`
    - Mapping file excluding samples with outlier diet: `map-subset.biom`
    - OTU table excluding samples with outlier diet: `otutable-subset.biom`

9. Move the files back from MSI to your computer using Filezilla  
 See instructions on [Getting Started Guide](../../README.md) to connect to MSI using Filezilla. Navigate to `/home/mice5992/<yourusername>/mice5992-2017/tutorials/corediv/`. Drag the `betaplots`, `taxaplots`, and `alphaplots` folders to your computer.
 
 
