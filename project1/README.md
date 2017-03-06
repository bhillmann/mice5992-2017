## MiCE 5992 Project 1

### Background
This is a short tutorial on how to get started on your individual project.

### Setup
1. Connect to MSI  
 Follow the steps in the [Getting Started Guide](../../README.md) to connect to MSI using SSH.

 When you first log in, you will be on the "login" node. You are not allowed to run computations on this node. Instead, you can get to an interactive node for running computations with this command:
 ```bash
    isub -n nodes=1:ppn=4 -m 8GB -w 02:00:00
 ```
 Note: At home you might want to request 8 hours instead of two as follows:
 ```bash
    isub -n nodes=1:ppn=4 -m 8GB -w 08:00:00
 ```

2. Load software  
 Load all of the software "modules" that you will need.
 ```bash
    module load qiime/1.9.1
    module load bowtie2
 ```

3. Go to the course repo directory
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

 Then change directories into the new folder `project1`. This is where you will do all of your work on MSI for this project:
 ```bash
    cd project1
 ```

 List the contents of the directory. At first it has only this README.md file:
 ```bash
    ls
 ```

### Analysis
4. Now proceed with the core diversity analyses and a/b testing using the tools you
 learned in the [Core diversity tutorial](../tutorials/corediv) and the [A/B testing tutorial](../tutorials/abtesting)

 **Note:** you should copy the mapping file over to your computer using FTP so that you can inspect it before proceeding.
 
