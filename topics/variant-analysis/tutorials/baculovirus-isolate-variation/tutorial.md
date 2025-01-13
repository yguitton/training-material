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

> <details-title> CpGV Isolate Information </details-title>
>
> Below is a table with further information on the CpGV isolates used.
>
> | Isolate | NCBI Genbank | NCBI SRA | Reference |
> |:------------------:|:------------------:|:------------------:|:------------------:|
> | CpGV-M | KM217575 | [SRR31589148](https://trace.ncbi.nlm.nih.gov/Traces?run=SRR31589148) | [Wennmann et al. 2020](https://doi.org/10.3390/v12060625) |
> | CpGV-S | KM217573 | [SRR31589147](https://trace.ncbi.nlm.nih.gov/Traces?run=SRR31589147) | [Wennmann et al. 2020](https://doi.org/10.3390/v12060625) |
> | CpGV-E2 | KM217577 | [SRR31589146](https://trace.ncbi.nlm.nih.gov/Traces?run=SRR31589146) | [Gueli Alletti et al. 2017](https://doi.org/10.3390/v9090250) |
> | CpGV-V15 | not available | [SRR31679023](https://www.ncbi.nlm.nih.gov/sra/SRX27041396) | [Fan et al. 2020](https://doi.org/10.1093/ve/veaa073) |
>
{: .details}

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
>        - *"Optional tags to output"*: ``
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

## Visualisierung der variablen SNV Positionen




# Conclusion

Sum up the tutorial and the key takeaways here. We encourage adding an overview image of the
pipeline used.