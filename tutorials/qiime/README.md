## MiCE 5992 Tutorial: QIIME

### Background
QIIME is a comprehensive tool for doing microbiome analysis. This tutorial is just an introduction
to the QIIME tool to allow you to try running a few commands and viewing the output.

### Setup
1. Connect to MSI
 Follow the steps in the [Getting Started page](../README.md) to connect to MSI using SSH.

 When you first log in, you will be on the "login" node. You are not allowed to run computations on this node. Instead, you can get to an interactive node for running computations with this command:
 ```bash
    isub -n nodes=1:ppn=4 -m 8GB -w 02:00:00
 ```
 This command might take a minute or two because you are waiting in line for an availabe computer node. The `nodes=1:ppn=4` means one computer node with 4 processors. The `-m 8GB` means you need 8GB of RAM, and the `-w 02:00:00` means you want up to 2 hours of time to work before you get kicked off.

 Then make sure that you are in the course directory, and not your home directory. The following command will list your current directory:
 ```bash
    pwd
 ```
 The current directory should be /home/mice5992/yourusername.
2. Load software
 Load all of the software "modules" that you will need.
 ```bash
    module load qiime/1.9.1
    module load bowtie2
 ```
 
3. Get the data
 Download the course repository to your folder on MSI:
 ```bash
    git clone https://github.com/danknights/mice5992-2017.git
 ```

 Then change directories into the course repository folder that you downloaded:
 ```bash
    cd mice5992-2017
 ```
 List the contents of the directory:
 ```bash
    ls
 ```

 Move to the `data` directory:
 ```bash
    cd data
 ```

 Move to the `globalgut` directory:
 ```bash
    cd globalgut
 ```

 Unzip the sequences file; list the directory contents before and after:
 ```bash
    ls
    unzip seqs.fna.zip
    ls
 ```

 Test how large the files are:
 ```bash
    du -hs *
 ```

 Peek at the first 10 lines of the file:
 ```bash
    head seqs.fna
 ```

 Count the number of lines, words, and characters in the file. How many sequences are in the file?
 ```bash
    wc seqs.fna
 ```

 Move up two directories, then down to the `qiime` directory in the `tutorials` directory:
 ```bash
    cd ..
    cd ..
    cd tutorials
    cd qiime
 ```
 
3. Compare all sequences to a reference database using NINJA-OPS.

 ```bash
    time python /home/mice5992/shared/NINJA-OPS-1.5.1/bin/ninja.py -i ../../data/globalgut/seqs.fna -o otus
    ls otus
 ```



