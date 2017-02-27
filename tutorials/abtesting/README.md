
To install the needed packages in R:

```
> install.packages(c('optparse','vegan','randomForest'),repo='http://cran.wustl.edu',dep=TRUE)
Warning in install.packages("optparse", repo = "http://cran.wustl.edu",  :
  'lib = "/panfs/roc/msisoft/R/3.2.2/lib64/R/library"' is not writable
Would you like to use a personal library instead?  (y/n) y
...
...
...
> q()
```


## MiCE 5992 Tutorial: A/B testing with QIIME

### Background
In this tutorial we will learn how to run tests for statistical significance of alpha diversity, beta diversity, and taxonomic profile using QIIME.

### Setup
1. Connect to MSI.
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
    cd abtesting
 ```

 List the contents of the directory:
 ```bash
    ls
 ```

### Background
There are three types of statistical testing that we will be doing in QIIME:

#### Taxonomic profile significance.

The goal of these tests is to answer the question: Is any species statistically associated with a particular experimental variable?

There are three different types of experimental variables that matter for these tests, each with a different test in QIIME:

1. Discrete variable with two groups (in the example data, AGE_GROUP has two groups). Use QIIME script [`group_significance.py`](http://qiime.org/scripts/group_significance.html) with flag `-s mann_whitney_u`. This uses the [Mann-Whitney U test](https://en.wikipedia.org/wiki/Mann%E2%80%93Whitney_U_test), which is a non-parametric test for different means across two groups (like a t-test). The non-parametric test is most reliable for microbiome data due to the many different types of distributions taxa and genes can have across microbiomes.

 Run an example:

 ```bash
    group_significance.py -i taxaplots/ninja_otutable_s10_min500_L6.biom -m ../../data/globalgut/map.txt -c AGE_GROUP -o genus_age_group_significance.txt -s mann_whitney_u
 ```
 
 Print the top single most significant genus:
 
 ```bash
    head -n 2 genus_age_group_significance.txt
 ```
 
 Were any of the test significant? Use the third column, FDR_P.
 
 Is it higher or lower in adults? Use the last two columns.

2. Discrete variable with more than two groups (in the example data, COUNTRY has three groups). Use QIIME script [`group_significance.py`](http://qiime.org/scripts/group_significance.html) with the default method. Here the default method is the [Kruskal-Wallis test](https://en.wikipedia.org/wiki/Kruskal%E2%80%93Wallis_one-way_analysis_of_variance), which is a non-parametric test for different means across three or more groups (like an ANOVA). A non-parametric tests is most reliable for microbiome data due to the many different types of distributions taxa and genes can have across microbiomes.

 Run an example:

 ```bash
    group_significance.py -i taxaplots/ninja_otutable_s10_min500_L6.biom -m ../../data/globalgut/map.txt -c COUNTRY -o genus_country_group_significance.txt -s kruskal_wallis
```

 Print the top 5 most significant genus:
 
 ```bash
    head -n 6 genus_country_group_significance.txt
 ```


3. Continuous variable (in the example data, AGE is continuous). Use QIIME script [`observation_metadata_correlation.py`](http://qiime.org/scripts/observation_metadata_correlation.html) with flag `-s spearman`. Spearman correlation is a non-parametric test.

 Run an example:

 ```bash
    observation_metadata_correlation.py -i taxaplots/ninja_otutable_s10_min500_L6.biom -m ../../data/globalgut/map.txt -c AGE -o genus_age_significance.txt -s spearman
 ```

 Print the top 5 most significant genus:
 
 ```bash
    head -n 6 genus_age_significance.txt
 ```


8. Move the files back from MSI to your computer using Filezilla  
 See instructions on [Getting Started Guide](../../README.md) to connect to MSI using Filezilla. Navigate to `/home/mice5992/<yourusername>/mice5992-2017/tutorials/corediv/`. Drag the `betaplots`, `taxaplots`, and `alphaplots` folders to your computer.
 
9. Repeat using other data  
 Choose one of the many studies with sequence files and mapping files in this directory:
 ```bash
    ls /home/knightsd/public/qiime_db/processed/
    ls /home/knightsd/public/qiime_db/processed/Bushman_enterotypes_cafe_study_1010_ref_13_8
 ```
 **Note:** If you choose a very large data set you will run out of memory or time. You may need to log out of the interactive node with "control-D" and rerun `isub` requesting more RAM and/or more time:

 ```bash
    isub -n nodes=1:ppn=4 -m 16GB -w 08:00:00
 ```

 Then on MSI make a new directory to work in and move into it:
 ```bash
    mkdir bonus
    cd bonus
 ```
 
  Now run OTU picking, the core diversity analyses, and the statistical testing above:
 ```bash
    python /home/mice5992/shared/NINJA-OPS-1.5.1/bin/ninja.py -i /home/knightsd/public/qiime_db/processed/Bushman_enterotypes_cafe_study_1010_ref_13_8/Bushman_enterotypes_cafe_study_1010_split_library_seqs.fna -o otus -p 4
    
    etc.
 ```

 After you finish running all core diversity analyses on the other data set, use Filezilla/FTP to move the outputs over to your computer. Also move the mapping file for that data set over to your computer, and open with Excel (or Google Sheets). Can you find a category that is interesting to run comparisons against? Use this information when examining the core diversity analyses on that study.

