---
layout: tutorial_hands_on

title: Deciphering baculovirus isolates using single nucleotide variants (SNV) and SNV specificities
subtopic: ''
zenodo_link: ''
level: Introductory
questions:
- How can the genetic variability of a baculovirus isolate be analysed?
- How can single nucleotide variants (SNV) be identified across multiple isolates?
- How can SNV be used to analyse the composition of an isolate based on SNV specificities?
objectives:
- Understand the significance of single nucleotide variants (SNVs) (or polymorphisms, SNPs) in baculovirus populations.
- Apply provided bioinformatic workflows and tools on provided sequence data.
- Interpret the output of the analysis to determine the composition of baculovirus isolates or samples.
- Evaluate the quality of SNV analysis to identify poetential sources of error.
- Learn to create your own sequence data and analyse it using the provided workflow and tool to explore the genetic variation of baculovirus populations.
time_estimation: 2H
abbreviations:
    CpGV: Cydia pomonella granulovirus
    NCBI: National Center for Biotechnology Information
    ORF: open reading frame
    SNV: Single nucleotide variant
    SRA: Sequence Read Archive
key_points:
- Baculovirus populations are heterogeneous and show genetic variability.
- Some SNV positions occur only in certain isolates and are therefore specific for that isolate.
- SNV specificities can be used as markers to identify isolates and determine mixtures.
contributors:
- wennmannj

---


# Introduction

Baculoviruses of the family *Baculoviridae* ({% cite Harrison2018 %}) are one of the most intensively 
studied viruses, not only because of their widespread application in biotechnology, medicine, and 
agriculture ({% cite vanOers2007 %}). Like all members of the class *Naldaviricetes*, 
baculoviruses have a circular large dsDNA genome that, in the family *Baculoviridae*, 
ranges between 90 to 180 kbp and can encode up to 180 open reading frames (ORF). 
A detailed description of the biology of the Baculoviridae family can be found in the
official report of the International Committee on Taxonomy of Viruses (ICTV) ({% cite Harrison2018 %}). A detailed summary can also be found on the website of the ICTV (https://ictv.global/).

> <details-title> A Baculovirus Genome </details-title>
>
> The genome of the isolate Autographa californica multiple nucleopolyhedrovirus isolate C6 (AcMNPV-C6)
> (family *Baculoviridae*, genus *Alphabaculovirus*, species *Alphabaculovirus aucalifornicae*) is one of the 
> best-studied baculovirus genomes and is 133,894 bp long ({% cite Ayres1994 %}). 
> It is the first fully sequenced genon of baculoviruses and today hundreds of genomes are fully sequenced
> and publically available at NCBI Genbank. The genome of AcMNPV-C6 encodes for 154 open reading frames (ORF)
> in both forward and reverse orientation (see figure). 
> So far, 38 ORFs were identified, which are encoded by all baculoviruses sequenced to date and are 
> called baculovirus core genes. In addition to the core genes, genes were found 
> that are encoded by baculoviruses from the genera *Alphabaculovirus* and *Betabaculovirus*. 
> 
> ![Alternative text](https://ictv.global/sites/default/files/inline-images/7651.ODD.Baculo.Fig2.v2.png "Figure: Schematic representation of the AcMNPV-C6 genome. ORFs and their orientation are indicated by arrows. (Figure from {% cite ICTV_AcMNPV_genome_figure %})")
>
{: .details}

The genome size makes it difficult to study genetic variation within a baculovirus population, 
especially since the most commonly used sequencing technique (Illumina sequencing) 
generates only short reads and requires genome assembly. Since genome assembly generates 
a consensus sequence that reflects the majority of a sequenced virus population, 
occuring genetic variation is masked. Tools for haplotype-sensitive assembly are 
available but so far have been establisehd for viruses with a relatively short genome 
but not for baculoviruses or other large dsDNA viruses (REFERENCES). Using Nanopore sequencing, 
it is possible to sequence signficiant fragments of  baculovirus genomes to determine major 
haplotypes ({% cite Wennmann2024 %}). 

Single nucleotide variants (SNV) have been proven as a powerful tool for analyzing 
the genetic variability of sequenced baculovirus isolates ({% cite Fan2020 %}). SNV 
are particularly useful for the analysis of intra-isolate or intra-sample specific 
variation, as a many bioinformatic workflows and tools are established for SNV determination 
and processing. For the identification of SNVs, Illumina sequencing data is mostly used, 
as this sequencing technique provides highly accurate reads with a very low probability 
of sequencing error. The data is usually provided and stored in fatsq or fastqsanger format.

When a baculovirus sample or isolate is sequenced, a dataset of sequence reads is 
obtained that consists of a multitude of fragmented genomes and the excact reconstruction 
of individual whole genomes is no longer possible. However, variable SNV positions can 
be used as markers to count the frequency of the nucleotides that occur in the SNV positions. 
The determination of the nucleotides is only possible because not one but many genomes 
were sequenced. Therefor, the SNVs reflect the genetic variability of the virus population itself. 

Although deletions and insertions can also occur, these are not covered in this tutorial.

When multiple baculovirus isolates have been sequenced, SNV positions can be determined 
that are specific to only certain isolates. These specific SNV markers can then be used 
to identify and isolate based on sequencing data only, even when the isolate is present 
in a mixture with other isolates. To enable this identification of baculovirus isolates, 
SNV positions must be determined across multiple isolates using a common reference sequence. 
This reference serves as an anchor for the detected SNV positions and must be chosen with care. 
Based on the reference and the SNVs, SNV specificities can be determined for individual isolates.

The tutorial presented here aims to explain...
- the criteria for a suitable reference genome,
- a workflow that can be used to call SNVs across multiple sequenced baculovirus isolates,
- what is meant by SNV specificities and
- how to determine the composition of an isolate based on other previously sequenced baculovirus isolates.

The workflow is based on sequencing data from the Cydia pomonella granulovirus (CpGV) 
(family *Baculoviridae*, genus *Betabaculovirus*). CpGV is used commercially in agriculture 
for the biological control the larvae of the codling moth (*Cydia pomonella*), which cause 
significant losses to  fruit crops, such als apple and pear.

> <agenda-title></agenda-title>
>
> In this tutorial, we will cover:
>
> 1. TOC
> {:toc}
>
{: .agenda}

# Dataset Preparation

Let's start at the very beginning with a new history and a detailed description 
of the sequencing datasets as well as the reference sequence. 
We will also have a closer look at the Illumina sequencing datasets, what we 
know so far about them and what we can expect from the analysis. By doing this, 
we will work our way towards our goal step by step.

> <hands-on-title>Prepare the Galaxy history</hands-on-title>
>
> 1. Create a new history for this analysis
>
>    {% snippet faqs/galaxy/histories_create_new.md %}
>
> 2. Rename the history
>
>    {% snippet faqs/galaxy/histories_rename.md %}
>
{: .hands_on}

## Reference Genome from NCBI Genbank

Selecting the right or most suitable reference sequence is important if not critical for the entire analysis. The referen genome used in this tutorial is the Cydia pomonella granulovirus (Mexican isolate, CpGV-M). The function of the reference is to act as an anchor point to link detected SNV position in all sequenced and analyzed isolates. Selecting a correct reference genome is critical, because it must be as closely related as possible to the sequenced samples/isolates. Therefore, it is best to use a reference from the same species that has been well analyzed by previous studies or the scientific community.  The following step will download the NCBI Accession Number `KM217575`, which corresponds to the `Cydia pomonella granulovirus isolate CpGV-M, complete genome`. It will later serve as the reference genome for the detection of SNV positions.  


> <hands-on-title> Reference genome download </hands-on-title>
>
> 1. {% tool [NCBI Accession Download](toolshed.g2.bx.psu.edu/repos/iuc/ncbi_acc_download/ncbi_acc_download/0.2.8+galaxy0) %} with the following parameters:
>    - *"Select source for IDs"*: `Direct Entry`
>        - *"ID List"*: `KM217575`
>    - *"Molecule Type"*: `Nucleotide`
>    - *"File Format"*: `FASTA` 
>    - Click Run Tool
>
>    > <warning-title>Use a single reference genome only!</warning-title>  
>    > **The NCBI Accession Download** tool accepts multiple NCBI accession numbers as input, which should be avoided, otherwise the workflow will fail. If you still want to use multiple reference genomes, then I recommend to run the entire workflow for each reference genome separately.
>    {: .warning}
>
> 2. {% tool [Collapse Collection](toolshed.g2.bx.psu.edu/repos/nml/collapse_collections/collapse_dataset/5.1.0) %} with the following parameters:
>    - {% icon param-file %} *"Collection of files to collapse into single dataset"*: `output` (output of **NCBI Accession Download** {% icon tool %})
>    - Click Run Tool
>
>    > <comment-title> Collapse Genbank files </comment-title>
>    > **NCBI Accession Download** accepts multiple accession numbers and creates a list as output. 
>    > Therefore, its output can contain multiple records. For this analysis just one reference genome
>    > is required and the list needs to be converted into a single file.
>    {: .comment}
>
> 3. {% tool [Replace Text](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_replace_in_line/9.3+galaxy1) %} with the following parameters:
>    - {% icon param-file %} *"File to process"*: `output` (output of **Collapse Collection** {% icon tool %})
>    - In *"Replacement"*:
>        - {% icon param-repeat %} *"Insert Replacement"*
>            - *"Find pattern"*: `^>.*$`
>            - *"Replace with:"*: `>CpGV-M `
>    - In "Configure Output: 'list_paired'":
>      - *Rename dataset*: `CpGV reference`
>    - Click Run Tool
>
>    > <comment-title> What the tool does... </comment-title>
>    > The find pattern `^>.*$` searches for the `>` and all characters that follow.
>    > Then everything (the entire line) is replaced by `>CpGV-M`. 
>    {: .comment}
>
>    > <comment-title> Why we change the name... </comment-title>
>    > The reference genome is stored in a single file in FASTA format. After downloading from NCBI, the name of the reference is `>KM217575.1 Cydia pomonella granulovirus isolate CpGV-M, complete genome`. The name is very long and can cause issues during later analysis (in R or Python). Therefore, I recommend to replace the name with the **Replace text in entire line** tool.
>    {: .comment}
>
{: .hands_on}

## Paired-end Sequencing Data from NCBI SRA

The tutorial is based on Illumina data sets from several isolates of the Cydia pomonella granulovirus (CpGV). 
The CpGV is one of the most well studied baculoviruses because many isolates have been sequenced and sequence 
data sets are available at NCBI Genbank and NCBI SRA. We will use four CpGV isolates to decipher their 
intra-isolate specific variation and try to draw conclusios about the isolate's homoe- or heterogenity. 
We will also encounter a mixed isolate (a more or less clean mixture of other previously sequenced CpGV isoaltes) 
and learn how to recognize it. In addition, we will learn how to determine the composition 
of this mixted isolate based on other sequenced CpGV isolates.

> <comment-title> Detailed CpGV Isolate Information </comment-title>
>
> For those who want to delve deeper into the data sets, I have provided a table with links to NCBI SRA and related publications.
>
> | Isolate | NCBI Genbank | NCBI SRA | Reference |
> |:------------------:|:------------------:|:------------------:|:------------------:|
> | CpGV-M | KM217575 | [SRR31589148](https://trace.ncbi.nlm.nih.gov/Traces?run=SRR31589148) | [Wennmann et al. 2020](https://doi.org/10.3390/v12060625) |
> | CpGV-S | KM217573 | [SRR31589147](https://trace.ncbi.nlm.nih.gov/Traces?run=SRR31589147) | [Wennmann et al. 2020](https://doi.org/10.3390/v12060625) |
> | CpGV-E2 | KM217577 | [SRR31589146](https://trace.ncbi.nlm.nih.gov/Traces?run=SRR31589146) | [Gueli Alletti et al. 2017](https://doi.org/10.3390/v9090250) |
> | CpGV-V15 | No assembly available | [SRR31679023](https://www.ncbi.nlm.nih.gov/sra/SRX27041396) | [Fan et al. 2020](https://doi.org/10.1093/ve/veaa073) |
{: .comment}

Follow the steps below to download the four Illumina datasets published at NCBI SRA.

> <hands-on-title>NCBI SRA Data Download</hands-on-title>
>
>    Run {% tool [Download and Extract Reads in FASTAQ format from NCBI SRA](toolshed.g2.bx.psu.edu/repos/iuc/sra_tools/fastq_dump/3.1.1+galaxy1) %} with the following parameters:
>
>    - *"Select input type"*: `SRR accession`
>    - *Accession*: `SRR31589146, SRR31589147, SRR31589148, SRR31679023`
>    - *Select output format*: `gzip compressed fastq`
>    - In "Configure Output: 'list_paired'":
>      - *Rename dataset*: `CpGV paired read list collection`
>    - Click Run Tool
>
>    > <comment-title> Take a cup of coffee </comment-title>
>    > Downloading the data from NCBI SRA may take a while.
>    > It is a good opportunity to have a cup of coffee or tea.
>    {: .comment}
>
{: .hands_on}

# Read Preprocessing and Quality Control

After the reference genome and the paired-end Illumina reads are loaded in the history, 
it is time to start the analysis. First, the reads needs to be adapter trimmed and
quality filtered. 

> <tip-title>Learn more about quality of reads!</tip-title>
> Before and after trimming, it is usually a good idea to check the quality of the reads using FASTQC. 
> Howver, we will omit this step here. 
> If you are interested in learning more about read quality, I recommend the check the [Galaxy Training Quality Control]( {% link topics/sequence-analysis/tutorials/quality-control/tutorial.md %} ) tutorial.
{: .tip}


> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Trim Galore!](toolshed.g2.bx.psu.edu/repos/bgruening/trim_galore/trim_galore/0.6.7+galaxy0) %} with the following parameters:
>    - *"Is this library paired- or single-end?"*: `Paired Collection`
>        - {% icon param-collection %} *"Select a paired collection"*: `CpGV paired read list collection` (output of **Download and Extract Reads in FASTAQ format from NCBI SRA** {% icon tool %})
>    - *"Advanced settings"*: `Full parameter list`
>        - *"Trim low-quality ends from reads in addition to adapter removal (Enter phred quality score threshold)"*: `30`
>        - *"Discard reads that became shorter than length N"*: `50`
>        - *"specify if you would like to retain unpaired reads"*: `Do not output unpaired reads`
>    - *"RRBS specific settings"*: `Use defaults (no RRBS)`
>    - *"Trimming settings"*: `Use defaults`
>    - Click Run Tool
>
{: .hands_on}


# Mapping of Reads to the Reference Genome

Now the filtered reads of the individual isolates are mapped independently against the CpGV-M reference. 
The key is that each isolate is mapped separately against the identical reference genome, so that in the end we get a Binary Alignment Mapping (BAM) file for each isolate.
After that, everything we do with the sequence data is linked to the common reference.

> <hands-on-title> Read mapping using bcftools </hands-on-title>
>
> 1. {% tool [Map with BWA-MEM](toolshed.g2.bx.psu.edu/repos/devteam/bwa/bwa_mem/0.7.17.2) %} with the following parameters:
>    - *"Will you select a reference genome from your history or use a built-in index?"*: `Use a genome from history and build index`
>        - {% icon param-file %} *"Use the following dataset as the reference sequence"*: `CpGV reference` (output of **Replace Text** {% icon tool %})
>    - *"Single or Paired-end reads"*: `Paired Collection`
>        - {% icon param-file %} *"Select a paired collection"*: `trimmed_reads_paired_collection` (output of **Trim Galore!** {% icon tool %})
>    - *"Set read groups information?"*: `Set read groups (Picard style)`
>        - *"Auto-assign"*: `Yes`
>        - *"Auto-assign"*: `Yes`
>        - *"Auto-assign"*: `Yes`
>    - *"Select analysis mode"*: `1.Simple Illumina mode`
>    - Click Run Tool
>
{: .hands_on}


# SNP Calling and Variant Detection

The key part of the analysis is the determination of variable SNV positions, which is carried out in the following step. 
Insertions/Deletions (indels) are deliberately omitted because they are not relevant for this analysis.

> <hands-on-title> Variable SNV positions </hands-on-title>
>
> 1. {% tool [bcftools mpileup](toolshed.g2.bx.psu.edu/repos/iuc/bcftools_mpileup/bcftools_mpileup/1.10) %} with the following parameters:
>    - *"Alignment Inputs"*: `Multiple BAM/CRAMs`
>        - {% icon param-file %} *"Input BAM/CRAMs"*: `bam_output` (output of **Map with BWA-MEM** {% icon tool %})
>    - *"Choose the source for the reference genome"*: `History`
>        - {% icon param-file %} *"Genome Reference"*: `output` (Input dataset)
>    - In *"Indel Calling"*:
>        - *"Perform INDEL calling"*: `Do not perform INDEL calling`
>    - In *"Input Filtering Options"*:
>        - *"Max reads per BAM"*: `1024`
>        - *"Set filter by flags"*: `Do not filter`
>        - *"Quality Options"*: `defaults`
>        - *"Select read groups to include or exclude"*: `use defaults`
>    - In *"Restrict to"*:
>        - *"Regions"*: `Do not restrict to Regions`
>        - *"Targets"*: `Do not restrict to Targets`
>    - In *"Output options"*:
>        - *"Optional tags to output"*: `DP (Number of high-quality bases)`
>        - *"Optional tags to output"*: `DPR (Number of high-quality bases for each observed allele)`
>    - *"Output type"*: `uncompressed VCF`
>    - Click Run Tool
>
>    > <comment-title> What bcftools mpileup does... </comment-title>
>    > bcftools mpileup calculates the nucleotide coverage for each position in the reference genome based on the input BAM files. It enables preparation for variant analysis. 
>    {: .comment}
>
> 2. {% tool [bcftools call](toolshed.g2.bx.psu.edu/repos/iuc/bcftools_call/bcftools_call/1.15.1+galaxy5) %} with the following parameters:
>    - {% icon param-file %} *"VCF/BCF Data"*: `output_file` (output of **bcftools mpileup** {% icon tool %})
>    - In *"Restrict to"*:
>        - *"Regions"*: `Do not restrict to Regions`
>    - In *"Consensus/variant calling Options"*:
>        - *"Calling method"*: `Multiallelic and rare-variant caller`
>            - *"Constrain"*: `Do not constrain`
>                - *"Targets"*: `Do not restrict to Targets`
>    - In *"File format Options"*:
>        - *"Regions"*: `Do not restrict to Regions`
>    - In *"Input/output Options"*:
>        - *"Keep alts"*: `Yes`
>        - *"Output variant sites only"*: `Yes`
>    - *"Output type"*: `uncompressed VCF`
>    - Click Run Tool
>
>    > <comment-title> What bcftools call does... </comment-title>
>    > bcftools call performs the actual variant detection. It removes non variant and keeps variant sites only.
>    {: .comment}
>
{: .hands_on}

What you get is a file in Variant Call Format (VCF), which can be difficult to understand at first glance. It is important to note that the file begins with a large header, lines that begin with two hashtags (##), which contain details of the analysis and the data set. After the header, there is a table with a line that contains the column names. This line begins with just one hashtag (#). After that, the results are displayed in a tab-separated format. In our VCF example, some columns have the following abbreviations and meaning (I just select a few that are important to us in this tutorial):

| Fixed fields  | Description  |
|---:|:---|
|**CHROM**  |Chromosome (name of the reference, in our case CpGV-M)  |
|**POS**  |Position (position in the reference genome)   |
|**REF**  |Nucleotide of the Referance at the corresponding position (POS)   |
|**ALT**   |Alternative nucleotides detected at this position in the sequencing data.   |
|**FORMAT**   |Describes the content of the *sample column* reported in the VCF file. In our case GT:PL:DP:DPR.   |
|**SRR31589146**   |1st sample column: The results for the sequence data SRR31589146 in the format specified in FORMAT.   |
|**SRR31589147**   |2nd sample column: The results for the sequence data SRR31589147 in the format specified in FORMAT.   |
|**SRR31589148**   |3rd sample column: The results for the sequence data SRR31589148 in the format specified in FORMAT.   |
|**SRR31679023**   |4th sample column: The results for the sequence data SRR31679023 in the format specified in FORMAT.


To understand how the data is stored, we have to look at FORMAT in detail. This is where two values are of great importance: DP and DPR.

|Genotype&nbsp;field|Description   |
|---:|:---|
|**DP**   |Read depth (number of nucleotides) at this position for this sample.   |
|**DPR**   |The read depth for each allele. Here, the first value corresponds to the reference nucleotide (REF), the second to the first possible allele (ALT1), the second to the second possible allele (ALT2) and the third value to the last possible allele (ALT3).

> <comment-title>DPR functional, but deprecated</comment-title>
> If you start **bcftools mpileup** with the *Optional tags to output* `DPR (Number of high quality bases for each observed allele)` option, you will see a warning in the information panel of the VCF file: `[warning] tag DPR functional, but deprecated. Please switch to AD in future`. At the time of writing this tutorial, I was using DPR. It works the same way with *Optional tags to output* option `AD` (instead of DPR), but you will need to adjust something later in the workflow. The tutorial will be switched to AD in the near future. For now, we stick with DPR.
{: .comment}

> <tip-title>Learn more about variant analysis on diploid and non-diploid data!</tip-title>
> Also take a look at other tutorials that deal with non-diploid (but also diploid) data sets to perform a variant analysis. Broadening your horizons is always important. I recommend the check the tutorials on ... 
> * [Calling variants in diploid systems]( {% link topics/variant-analysis/tutorials/dip/tutorial.md %} ) and.
> * [Calling variants in non-diploid systems]( {% link topics/variant-analysis/tutorials/non-dip/tutorial.md %} ).
> 
> Maybe later? Then let's continue.
{: .tip}

# VCF to table transformation

Now we come to an exciting part, because we have all the information we need to analyse the genetic variation within the sequenced virus populations. The data is only hidden in the VCF file and is difficult for the beginner in bioinformatics to see. We have the positions (`POS`), which were detected as variable in the virus populations. In addition, we know the number of all reads (and thus also nucleotides) in these positions (represented by `DP`). By using `DPR`, we obtain information on how often the alleles (the four possible nucleotides) occur at a particular position. To analyse `DP` and `DPR`, we first have to access it because the information is hidden in each *sample column* in the `FORMAT` genotype data. If we look at the first position `POS = 246` in sample column `SRR31589146`, the following data is visible:     
`1/1:255,98,0,255,255,255,255,255,255,255:885:106,773,6,0`.  
The information provided by the FORMAT field explains the division of the data by colons: `GT:PL:DP:DPR`.

We can break it down like this...

| FORMAT genotype field | Value |
|-----------------------:|:-------|
|GT                     |1/1    |
|PL                     |255,98,0,255,255,255,255,255,255,255|
|DP                     |885    |
|DPR                    |106,773,6,0|

GT = Genotype information, which cannot be used with virus populations!  
PL = Phred-scaled genotype likelihood (also not useable for us, because we do not have a diploid organism!)

DPR can be broken down even further, since the individual values, which are separated by commas this time, can be assigned to the reference or the alternative nucleotides. In a virus population, four nucleotides (A, T, G and C) can theoretically occur at each position. One nucleotide defines the reference, leaving three alternatives: first (`ALT1`), second (`ALT2`) and third (`ALT3`) alternative. 



|CHROM   |POS   |DP   |DPR           | ALT1  |ALT2    |ALT3  |  
|:------:|:----:|:---:|:------------:|:-----:|:------:|:----:|
|CpGV-M  |246   |885  |106,773,6,0   |773    |6       |0     |

If we now divide the absolute frequencies of `ALT1 = 773`, `ALT2 = 6` and `ALT3 = 0` by `DP = 885`, we get the relative frequencies (`REL.ALT`):

|ALLELE     |REL.ALT     |
|:---------:|:----------:|
|ALT1       |0.873446    |
|ALT2       |0.00677966  |
|ALT3       |0           |


> <hands-on-title> Transfrom VCF to tab-deliminated table </hands-on-title>
>
> 1. {% tool [VCFtoTab-delimited:](toolshed.g2.bx.psu.edu/repos/devteam/vcf2tsv/vcf2tsv/1.0.0_rc1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Select VCF dataset to convert"*: `output_file` (output of **bcftools call** {% icon tool %})
>    - *"Fill empty fields with"*: `NULL`
>    - Click Run Tool
>
>    > <comment-title> An easier-to-read table </comment-title>
>    > This tool creates a table from the VCF file. The columns are tab-deliminated. Take a look at table and see if it is now easier to read. It can also be imported to R/RStudio/Excel more easily.
>    {: .comment}
>
> 2. {% tool [Text reformatting](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_awk_tool/9.3+galaxy1) %} with the following parameters:
>    - {% icon param-file %} *"File to process"*: `outfile` (output of **VCFtoTab-delimited** {% icon tool %})
>    - *"AWK Program"*: *Paste the code from the code box below.*
> > <code-in-title>awk</code-in-title>
> > ```
> > BEGIN { FS="\t"; OFS="\t" }
> > NR == 1 {
> >     # Print the new header
> >     print $0, "ALLELE", "DPR.ALLELE", "REL.ALT", "REL.ALT.0.05";
> >     next;
> > }
> > {
> >     # Create a unique key for position and sample
> >     pos_sample_key = $2 "_" $23;
> > 
> >     if (last_pos != $2) {         # When a new position starts
> >         delete sample_count;      # Reset the sample counter
> >         last_pos = $2;            # Update the current position
> >     }
> > 
> >     # Split the DPR column into values
> >     split($25, dpr_values, ",");
> > 
> >     # Count the occurrences of each sample per position
> >     sample_count[$23]++;
> >     dpr_index = sample_count[$23] + 1;  # Index for the alternate allele (starting at 2)
> > 
> >     # Check if the index is valid
> >     if (dpr_index <= length(dpr_values)) {
> >         allele = "ALT" (dpr_index - 1);            # Determine the allele
> >         dpr_value = dpr_values[dpr_index];         # Get the corresponding DPR value
> >         rel_alt = (dpr_value / $24);               # Calculate REL.ALT (DPR.ALLELE / DP)
> >         rel_alt_filtered = (rel_alt >= 0.05) ? rel_alt : 0;  # Filter REL.ALT values < 0.05
> >         print $0, allele, dpr_value, rel_alt, rel_alt_filtered;  # Output with new columns
> >     }
> > }
> > ```
> {: .code-in}
>
>    - Click Run Tool
> 
>    > <comment-title> Create ALLELE and REL.ALT columns </comment-title> 
>    > The **text reformatting** tool allows the use of AWK code. AWK is for text processing and to performing complex tasks on data sets (such as tab-delimited files). We will come across AWK scripts again later. Here is a brief summary of what it does: 
>    > * Splitting `DPR` data into separate allele counts.   
>    > * Calculating the relative allele frequencies (`REL.ALT`) for each allele.  
>    > * Filtering out relative frequencies below a threshold of 0.05 and storing the result in `REL.ALT.0.05`.  
>    {: .comment}
>
{: .hands_on}


The output table is complex and shows the relative frequency (`REL.ALT`) for each of the three alternative alleles/nucleotides (`ALT1`, `ALT2` and `ALT3`) in each position (`POS`) and sequenced CpGV isolate (`SAMPLE`). In column `REL.ALT.0.05`, values of the `REL.ALT < 0.05` were set to 0 to set a threshold. We will see later why this is sometimes important.

Below is the table with selected relevant columns only. `REL` and `ALT` show the reference and alternative nucleotide, respectively.    

| #CHROM | POS | REF | ALT | SAMPLE      | DP  | DPR         | ALLELE | DPR.ALLELE | REL.ALT    | REL.ALT.0.05 |
|--------|-----|-----|-----|-------------|-----|-------------|--------|------------|------------|--------------|
| CpGV-M | 246 | C   | T   | SRR31589146 | 885 | 106,773,6,0 | ALT1   | 773        | 0.873446   | 0.873446     |
| CpGV-M | 246 | C   | T   | SRR31589147 | 878 | 4,873,1,0   | ALT1   | 873        | 0.994305   | 0.994305     |
| CpGV-M | 246 | C   | T   | SRR31589148 | 934 | 799,133,1,1 | ALT1   | 133        | 0.142398   | 0.142398     |
| CpGV-M | 246 | C   | T   | SRR31679023 | 845 | 42,803,0,0  | ALT1   | 803        | 0.950296   | 0.950296     |
| CpGV-M | 246 | C   | G   | SRR31589146 | 885 | 106,773,6,0 | ALT2   | 6          | 0.00677966 | 0            |
| CpGV-M | 246 | C   | G   | SRR31589147 | 878 | 4,873,1,0   | ALT2   | 1          | 0.00113895 | 0            |
| CpGV-M | 246 | C   | G   | SRR31589148 | 934 | 799,133,1,1 | ALT2   | 1          | 0.00107066 | 0            |
| CpGV-M | 246 | C   | G   | SRR31679023 | 845 | 42,803,0,0  | ALT2   | 0          | 0          | 0            |
| CpGV-M | 246 | C   | A   | SRR31589146 | 885 | 106,773,6,0 | ALT3   | 0          | 0          | 0            |
| CpGV-M | 246 | C   | A   | SRR31589147 | 878 | 4,873,1,0   | ALT3   | 0          | 0          | 0            |
| CpGV-M | 246 | C   | A   | SRR31589148 | 934 | 799,133,1,1 | ALT3   | 1          | 0.00107066 | 0            |
| CpGV-M | 246 | C   | A   | SRR31679023 | 845 | 42,803,0,0  | ALT3   | 0          | 0          | 0            |


# Replace SRA names with virus abbreviations

One thing that stands out are the SAMPLE names, which were taken automatically from the NCBI SRA datasets. Since it is difficult to remember which virus isolate is behind which SRA number, we can replace the accession numbers with proper names. This makes the table even easier to read and later we can use the information directly to display the SNV positions. 

> <hands-on-title> Replace sample by virus names </hands-on-title>
>
> 1. {% tool [Replace Text](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_replace_in_column/9.3+galaxy1) %} with the following parameters:
>    - {% icon param-file %} *"File to process"*: `out_file1` (output of **VCFtoTab-delimited:** {% icon tool %})
>    - In *"Replacement"*:
>        - {% icon param-repeat %} *"Insert Replacement"*
>            - *"in column"*: `c23`
>            - *"Find pattern"*: `SRR31589148`
>            - *"Replace with"*: `CpGV-M`
>        - {% icon param-repeat %} *"Insert Replacement"*
>            - *"in column"*: `c23`
>            - *"Find pattern"*: `SRR31589147`
>            - *"Replace with"*: `CpGV-S`
>        - {% icon param-repeat %} *"Insert Replacement"*
>            - *"in column"*: `c23`
>            - *"Find pattern"*: `SRR31589146`
>            - *"Replace with"*: `CpGV-E2`
>        - {% icon param-repeat %} *"Insert Replacement"*
>            - *"in column"*: `c23`
>            - *"Find pattern"*: `SRR31679023`
>            - *"Replace with"*: `CpGV-V15`
>
>    > <question-title>What is replaced by what?</question-title>
>    > 1. Can you say which SRA number was replaced by which isolate abbreviation?
>    >    > <solution-title>Answer:</solution-title>
>    >    > * SRR31589148 was replaced by CpGV-M  
>    >    > * SRR31589147 was replaced by CpGV-S  
>    >    > * SRR31589146 was replaced by CpGV-E2  
>    >    > * SRR31679023 was replaced by CpGV-V15  
>    >    {: .solution}
>    {: .question}
>
{: .hands_on}

# Reduce complexity of SNV table to first alternative



> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Filter](Filter1) %} with the following parameters:
>    - {% icon param-file %} *"Filter"*: `outfile` (output of **Text reformatting** {% icon tool %})
>    - *"With following condition"*: `c28=='ALT1'`
>
>    ***TODO***: *Check parameter descriptions*
>
>    ***TODO***: *Consider adding a comment or tip box*
>
>    > <comment-title> short description </comment-title>
>    >
>    > A comment about the tool or something else. This box can also be in the main text
>    {: .comment}
>
{: .hands_on}





## SNV plot - Homogenity/heterogenity check

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Scatterplot with ggplot2](toolshed.g2.bx.psu.edu/repos/iuc/ggplot2_point/ggplot2_point/3.4.0+galaxy1) %} with the following parameters:
>    - {% icon param-file %} *"Input in tabular format"*: `out_file1` (output of **Filter** {% icon tool %})
>    - *"Column to plot on x-axis"*: `2`
>    - *"Column to plot on y-axis"*: `30`
>    - *"Plot title"*: `SNV plot`
>    - *"Label for x axis"*: `Reference Genome Position of CpGV-M`
>    - *"Label for y axis"*: `Relative nucleotide frequency `
>    - In *"Advanced options"*:
>        - *"Type of plot"*: `Points only (default)`
>            - *"Data point options"*: `Default`
>        - *"Plotting multiple groups"*: `Plot multiple groups of data on individual plots`
>            - *"column differentiating the different groups"*: `23`
>        - *"Axis title options"*: `Default`
>        - *"Axis text options"*: `Default`
>        - *"Plot title options"*: `Default`
>        - *"Grid lines"*: `Hide major and minor grid lines`
>        - *"Axis scaling"*: `Automatic axis scaling`
>    - In *"Output Options"*:
>        - *"Unit of output dimensions"*: `Centimeters (cm)`
>        - *"width of output"*: `40.0`
>        - *"height of output"*: `12.0`
>        - *"dpi of output"*: `200.0`
>
>    ***TODO***: *Check parameter descriptions*
>
>    ***TODO***: *Consider adding a comment or tip box*
>
>    > <comment-title> short description </comment-title>
>    >
>    > A comment about the tool or something else. This box can also be in the main text
>    {: .comment}
>
{: .hands_on}


# SNV Specificity determination

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Text reformatting](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_awk_tool/9.3+galaxy1) %} with the following parameters:
>    - {% icon param-file %} *"File to process"*: `out_file1` (output of **Filter** {% icon tool %})
>    - *"AWK Program"*: `BEGIN { FS=\t; OFS=\t }
NR == 1 {
    # Drucke den Header und füge die neue Spalte SPEC hinzu
    print $0, SPEC;
    next;
}

{
    # Wenn wir eine neue Position erreichen, bereite die Spezifität vor
    if ($2 != current_pos) {
        # Verteile die berechnete Spezifität an alle Zeilen der aktuellen Position
        for (i in pos_lines) {
            # Füge SNV specificity:  vor die Spezifität hinzu
            final_spec = (specificity ==  ? 0 : SNV specificity:  specificity);
            print pos_lines[i], final_spec;
        }
        # Setze Variablen für die neue Position zurück
        delete pos_lines;
        specificity = ;
        current_pos = $2;
    }

    # Speichere die aktuelle Zeile für später
    pos_lines[NR] = $0;

    # Bedingungen für die Berechnung der Spezifität
    if ($28 == ALT1 && ($23 == CpGV-E2 || $23 == CpGV-S || $23 == CpGV-M) && $31 > 0) {
        # Konkateniere die Isolate-Namen mit  + , wenn die REL.ALT.0.05 > 0 ist
        specificity = (specificity ==  ? $23 : specificity  +  $23);
    }
}

END {
    # Verteile die Spezifität für die letzte Position
    for (i in pos_lines) {
        # Füge SNV specificity:  vor die Spezifität hinzu
        final_spec = (specificity ==  ? 0 : SNV specificity:  specificity);
        print pos_lines[i], final_spec;
    }
}`
>
>    ***TODO***: *Check parameter descriptions*
>
>    ***TODO***: *Consider adding a comment or tip box*
>
>    > <comment-title> short description </comment-title>
>    >
>    > A comment about the tool or something else. This box can also be in the main text
>    {: .comment}
>
{: .hands_on}

# SNV specificity visualisation

## Understanding SNV specificities

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Filter](Filter1) %} with the following parameters:
>    - {% icon param-file %} *"Filter"*: `outfile` (output of **Text reformatting** {% icon tool %})
>    - *"With following condition"*: `c23=='CpGV-S'`
>    - *"Number of header lines to skip"*: `1`
>
>    ***TODO***: *Check parameter descriptions*
>
>    ***TODO***: *Consider adding a comment or tip box*
>
>    > <comment-title> short description </comment-title>
>    >
>    > A comment about the tool or something else. This box can also be in the main text
>    {: .comment}
>
>
> 2. {% tool [Scatterplot with ggplot2](toolshed.g2.bx.psu.edu/repos/iuc/ggplot2_point/ggplot2_point/3.4.0+galaxy1) %} with the following parameters:
>    - {% icon param-file %} *"Input in tabular format"*: `out_file1` (output of **Filter** {% icon tool %})
>    - *"Column to plot on x-axis"*: `2`
>    - *"Column to plot on y-axis"*: `30`
>    - *"Plot title"*: `SNV specificity plot for CpGV-S`
>    - *"Label for x axis"*: `Reference Genome Position of CpGV-M`
>    - *"Label for y axis"*: `Relative Nucleotide Frequency`
>    - In *"Advanced options"*:
>        - *"Type of plot"*: `Points only (default)`
>            - *"Data point options"*: `Default`
>        - *"Plotting multiple groups"*: `Plot multiple groups of data on individual plots`
>            - *"column differentiating the different groups"*: `32`
>        - *"Axis title options"*: `Default`
>        - *"Axis text options"*: `Default`
>        - *"Plot title options"*: `Default`
>        - *"Grid lines"*: `Hide major and minor grid lines`
>        - *"Axis scaling"*: `Automatic axis scaling`
>    - In *"Output Options"*:
>        - *"Unit of output dimensions"*: `Centimeters (cm)`
>        - *"width of output"*: `40.0`
>        - *"height of output"*: `12.0`
>        - *"dpi of output"*: `200.0`
>
>    ***TODO***: *Check parameter descriptions*
>
>    ***TODO***: *Consider adding a comment or tip box*
>
>    > <comment-title> short description </comment-title>
>    >
>    > A comment about the tool or something else. This box can also be in the main text
>    {: .comment}
>
{: .hands_on}


> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Filter](Filter1) %} with the following parameters:
>    - {% icon param-file %} *"Filter"*: `outfile` (output of **Text reformatting** {% icon tool %})
>    - *"With following condition"*: `c23=='CpGV-E2'`
>    - *"Number of header lines to skip"*: `1`
>
>    ***TODO***: *Check parameter descriptions*
>
>    ***TODO***: *Consider adding a comment or tip box*
>
>    > <comment-title> short description </comment-title>
>    >
>    > A comment about the tool or something else. This box can also be in the main text
>    {: .comment}
>
>
> 2. {% tool [Scatterplot with ggplot2](toolshed.g2.bx.psu.edu/repos/iuc/ggplot2_point/ggplot2_point/3.4.0+galaxy1) %} with the following parameters:
>    - {% icon param-file %} *"Input in tabular format"*: `out_file1` (output of **Filter** {% icon tool %})
>    - *"Column to plot on x-axis"*: `2`
>    - *"Column to plot on y-axis"*: `30`
>    - *"Plot title"*: `SNV specificity plot for CpGV-E2`
>    - *"Label for x axis"*: `Reference Genome Position of CpGV-M`
>    - *"Label for y axis"*: `Relative Nucleotide Frequency`
>    - In *"Advanced options"*:
>        - *"Type of plot"*: `Points only (default)`
>            - *"Data point options"*: `Default`
>        - *"Plotting multiple groups"*: `Plot multiple groups of data on individual plots`
>            - *"column differentiating the different groups"*: `32`
>        - *"Axis title options"*: `Default`
>        - *"Axis text options"*: `Default`
>        - *"Plot title options"*: `Default`
>        - *"Grid lines"*: `Hide major and minor grid lines`
>        - *"Axis scaling"*: `Automatic axis scaling`
>    - In *"Output Options"*:
>        - *"Unit of output dimensions"*: `Centimeters (cm)`
>        - *"width of output"*: `40.0`
>        - *"height of output"*: `12.0`
>        - *"dpi of output"*: `200.0`
>
>    ***TODO***: *Check parameter descriptions*
>
>    ***TODO***: *Consider adding a comment or tip box*
>
>    > <comment-title> short description </comment-title>
>    >
>    > A comment about the tool or something else. This box can also be in the main text
>    {: .comment}
>
{: .hands_on}


## Determining the mixture of CpGV-V15

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Filter](Filter1) %} with the following parameters:
>    - {% icon param-file %} *"Filter"*: `outfile` (output of **Text reformatting** {% icon tool %})
>    - *"With following condition"*: `c23=='CpGV-V15'`
>    - *"Number of header lines to skip"*: `1`
>
>    ***TODO***: *Check parameter descriptions*
>
>    ***TODO***: *Consider adding a comment or tip box*
>
>    > <comment-title> short description </comment-title>
>    >
>    > A comment about the tool or something else. This box can also be in the main text
>    {: .comment}
>
>
> 2. {% tool [Scatterplot with ggplot2](toolshed.g2.bx.psu.edu/repos/iuc/ggplot2_point/ggplot2_point/3.4.0+galaxy1) %} with the following parameters:
>    - {% icon param-file %} *"Input in tabular format"*: `out_file1` (output of **Filter** {% icon tool %})
>    - *"Column to plot on x-axis"*: `2`
>    - *"Column to plot on y-axis"*: `30`
>    - *"Plot title"*: `SNV specificity plot for CpGV-V15`
>    - *"Label for x axis"*: `Reference Genome Position of CpGV-M`
>    - *"Label for y axis"*: `Relative Nucleotide Frequency`
>    - In *"Advanced options"*:
>        - *"Type of plot"*: `Points only (default)`
>            - *"Data point options"*: `Default`
>        - *"Plotting multiple groups"*: `Plot multiple groups of data on individual plots`
>            - *"column differentiating the different groups"*: `32`
>        - *"Axis title options"*: `Default`
>        - *"Axis text options"*: `Default`
>        - *"Plot title options"*: `Default`
>        - *"Grid lines"*: `Hide major and minor grid lines`
>        - *"Axis scaling"*: `Automatic axis scaling`
>    - In *"Output Options"*:
>        - *"Unit of output dimensions"*: `Centimeters (cm)`
>        - *"width of output"*: `40.0`
>        - *"height of output"*: `12.0`
>        - *"dpi of output"*: `200.0`
>
>    ***TODO***: *Check parameter descriptions*
>
>    ***TODO***: *Consider adding a comment or tip box*
>
>    > <comment-title> short description </comment-title>
>    >
>    > A comment about the tool or something else. This box can also be in the main text
>    {: .comment}
>
{: .hands_on}





# Conclusion

Sum up the tutorial and the key takeaways here. We encourage adding an overview image of the
pipeline used.