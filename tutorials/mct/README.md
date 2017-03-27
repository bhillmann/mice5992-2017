## MiCE 5992 Tutorial: MCT study

### Background
In this tutorial we will take first steps at analyzing the MCT study data.

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
    module load bowtie2
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
    cd mct
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
5. Examine the OTU table
 There is already an OTU table provided. Examine the OTU table using `biom summarize-table`:

 ```bash
    biom summarize_table -i otus/otutable_n50000_s10_subset.biom -o stats.txt
    head -n 30 otus/stats.txt
 ```
 
 From this summary you should be able to answer these questions:
  - How many taxonomic groups are there?
  - How many samples?
  - How many sequences matched the database in the lowest coverage sample?

 To view more of this file, you can scroll up and down inside it with `less otus/stats.txt`.
 However, you will need to quit `less` by typing `q` before you do anything else.

 We notice that some "Blank" samples have a lot of sequences in them. We can list all lines of the file containing the word `Blank` with this command:

 ```bash
    grep "Blank" stats.txt
 ```
 What is the highest-depth blank? At what minimum depth should we trust samples?

6. Drop samples with < 50,000 sequences, Drop rare OTUs
 ```bash
    filter_samples_from_otu_table.py -n 50000 -i otutable.biom -o otutable_n50000.biom
    filter_otus_from_otu_table.py -s 10 -i otutable_n50000.biom -o otutable_n50000_s10.biom
 ```

7. Drop samples not present in the mapping file
 ```bash
    filter_samples_from_otu_table.py -i otutable_n50000_s10.biom -o otutable_n50000_s10_subset.biom --sample_id_fp map.txt
 ```

8. Sort the OTU table. This makes for nicer taxonomy bar charts.
 ```bash
    sort_otu_table.py -i otutable_n50000_s10_subset.biom -m map.txt -s StudyDayNo -o otutable_n50000_s10_subset_sortDay.biom
    sort_otu_table.py -i otutable_n50000_s10_subset_sortDay.biom -m map.txt -s UserName -o otutable_n50000_s10_subset_sortDayUser.biom
 ```

9. Make taxonomy stacked bar plots
 
 Filter even more taxa out; otherwise this will take forever. Run the command `summarize_taxa_through_plots.py`:

 ```bash
    filter_otus_from_otu_table.py -i otutable_n50000_s10_subset_sortDayUser.biom -o otutable_n50000_s10_subset_sortDayUser_s200.biom -s 200
    summarize_taxa_through_plots.py -i otutable_n50000_s10_subset_sortDayUser_s200.biom -p parameters.txt -o taxaplots
 ```
 **Note:** if you get an error from any QIIME script saying that the output directory already exists, then you can usually rerun the command with ` -f` at the end to force it to overwrite the existing directory. If that doesn't work, then remove the offending directory with `rm -rf <name of the directory>`.

10. Make beta diversity plots

 ```bash
    beta_diversity_through_plots.py -i otutable_n50000_s10_subset_sortDayUser.biom -o beta -p parameters.txt -m map.txt -v 
 ```

11. Make beta diversity plots with a custom axis for StudyDayNo

 ```bash
    make_emperor.py -i beta/bray_curtis_pc.txt -a "StudyDayNo" -o beta_custom_axis -m map.txt
 ```

12. Add vectors to the 3d plot

 ```bash
    make_emperor.py -i beta/bray_curtis_pc.txt -a "StudyDayNo" --add-vectors "UserName,StudyDayNo" -o beta_vectors -m map.txt
 ```

13. Move the files back from MSI to your computer using Filezilla  
 See instructions on [Getting Started Guide](../../README.md) to connect to MSI using Filezilla. Navigate to `/home/mice5992/<yourusername>/mice5992-2017/tutorials/corediv/`. Drag the `betaplots`, `taxaplots`, and `alphaplots` folders to your computer.
 
