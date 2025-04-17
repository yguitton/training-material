---
layout: tutorial_hands_on

title: 'Genome assembly using PacBio data'
zenodo_link: 'TO DO?'
tags:
  - assembly
  - pacbio
questions:
- How to perform a genome assembly with PacBio data ?
- How to check assembly quality ?
objectives:
- Assemble a Genome with PacBio data
- Assess assembly quality
time_estimation: 6h
level: Intermediate
key_points:
- PacBio data allows to perform good quality genome assembly
- Quast and BUSCO make it easy to compare the quality of assemblies
contributions:
  authorship:
  - abretaud
  - alexcorm
  - r1corre
  - lleroi
  - stephanierobin
  - scorreard
  funding:
  - gallantries

follow_up_training:
 - type: internal
   topic_name: genome-annotation
   tutorials:
     - repeatmasker

---



In this tutorial, we will assemble a genome of a species of fungi in the family Aspergillus, *Aspergillus niger*, from PacBio sequencing data. These data will be downloaded from ENA. The quality of the assembly obtained will be analyzed, in particular by comparing it to a reference assembly, available on ENA.


> <agenda-title></agenda-title>
>
> In this tutorial, we will cover:
>
> 1. TOC
> {:toc}
>
{: .agenda}

# Get data

We will use long reads sequencing data: HiFi (High Fidelity long reads) from PacBio sequencing of *Aspergillus niger* genome. This data is available on ENA. We will also use later a reference genome assembly downloaded from ENA.

## Get data from ENA

> <hands-on-title>Data upload from ENA</hands-on-title>
>
> 1. Create a new history for this tutorial
> 2. Import the files from [ENA](https://www.ebi.ac.uk/ena/browser/)
>
>    ```
>    ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR317/012/SRR31719412/SRR31719412_subreads.fastq.gz
>    ```
>
>    {% snippet faqs/galaxy/datasets_import_via_link.md %}
>
>
> 3. Rename the datasets
> 4. Check that the datatype is `fastq.gz`
>
>    {% snippet faqs/galaxy/datasets_change_datatype.md datatype="datatypes" %}
>
>
{: .hands_on}

## Get reference genome from ENA

> <hands-on-title>Data upload from ENA</hands-on-title>
>
> 1. Reference genome is available here: [ASM4765177v1 assembly for Aspergillus niger](https://www.ebi.ac.uk/ena/browser/view/GCA_047651775.1)
> 2. Download the `WGS Set FASTA (JBKZXA01.fasta.gz)` on your computer
> 3. Upload this file on Galaxy
> 4. Check that the datatype is `fasta.gz`
>
>    {% snippet faqs/galaxy/datasets_change_datatype.md datatype="datatypes" %}
>
{: .hands_on}

# Genome Assembly

{% include _includes/cyoa-choices.html option1="Hifiasm" option2="Flye" default="Hifiasm"
       text="[Hifiasm](https://github.com/chhylp123/hifiasm) and [Flye](https://github.com/mikolmogorov/Flye) are two well known assembler." %}
<div class="Hifiasm" markdown="1">

Hifiasm is a fast haplotype-resolved de novo assembler initially designed for PacBio HiFi reads. In general, hifiasm generates the assembly graphs in the GFA format, so a step of conversion to fasta is necessary. The GFA 1.0 format is a tab-delimited text format for describing a set of sequences and their overlap.
<br>
Hifiasm produces arguably the best single-sample telomere-to-telomere assemblies combing HiFi, ultralong and Hi-C reads, and it is one of the best haplotype-resolved assemblers for the trio-binning assembly given parental short reads. For a human genome, hifiasm can produce the telomere-to-telomere assembly in one day.

> <hands-on-title>Assembly with Hifiasm</hands-on-title>
>
> 1. {% tool [Hifiasm](https://toolshed.g2.bx.psu.edu/view/bgruening/hifiasm/5d365d5cbe9d) %} with the following parameters:
>    - *"Mode"*: `Standard`
>    - {% icon param-file %} *"Input reads"*: the raw data (fastq.gz)
>    - *"Output log file"*: Set to yes
>
>     The tool produces five datasets: Haplotype-resolved raw unitig graph, Haplotype-resolved processed unitig graph without small bubbles, Primary assembly contig graph, Alternate assembly contig graph, [hap1]/[hap2] contig graph.
>
> 2. {% tool [GFA to FASTA](https://toolshed.g2.bx.psu.edu/view/iuc/gfa_to_fa/e33c82b63727) %} with the following parameters:
>    - {% icon param-file %} *"Input GFA file"*: primary assembly contig graph
{: .hands_on}

> <question-title></question-title>
>
> What are the different output datasets from Hifiasm?
>
> > <solution-title></solution-title>
> >
> > - Haplotype-resolved raw unitig graph: This graph keeps all haplotype information, including somatic mutations and recurrent sequencing errors.
> > - Haplotype-resolved processed unitig graph without small bubbles: This graph 'pops' small bubbles in the raw unitig graph; small bubbles might be caused by somatic mutations or noise in data, which are not the real haplotype information.
> > - Primary assembly contig graph: This graph includes a complete assembly with long stretches of phased blocks, though there may be some haplotype collapse.
> > - Alternate assembly contig graph: This graph consists of all contigs that are discarded from the primary contig graph.
> > - [hap1]/[hap2] contig graph: Each graph consists of phased contigs (output only with Hi-C phasing enabled).
> >
> {: .solution}
>
{: .question}

</div>

<div class="Flye" markdown="1">

We will use *Flye*, a de novo assembler for single molecule sequencing reads, such as those produced by PacBio and Oxford Nanopore Technologies. It is designed for a wide range of datasets, from small bacterial projects to large mammalian-scale assemblies. The package represents a complete pipeline: it takes raw PacBio / ONT reads as input and outputs polished contigs. Flye also has a special mode for metagenome assembly. All informations about Flye assembler are here: [Flye](https://github.com/fenderglass/Flye/).

> <hands-on-title>Assembly with Flye</hands-on-title>
>
> 1. {% tool [Flye](toolshed.g2.bx.psu.edu/repos/bgruening/flye/flye/2.9+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Input reads"*: the raw data (fastq.gz)
>    - *"Mode"*: `PacBio HiFi`
>    - *"Number of polishing iterations"*: `1`
>    - *"Reduced contig assembly coverage"*: `Disable reduced coverage for initial disjointing assembly`
>
>     The tool produces four datasets: consensus, assembly graph, graphical fragment assembly and assembly info
{: .hands_on}

> <question-title></question-title>
>
> What are the different output datasets?
>
> > <solution-title></solution-title>
> >
> > - The first dataset (consensus) is a fasta file containing the final assembly (1461 contigs). You may notice that the result (contigs number) you obtained is sligthy different from the one presented here. This is due to the Flye assembly algorithm which doesn't always give the eact same results.
> > - The second and third dataset are assembly graph files. These graphs are used to represent the final assembly of a genome, they are based on reads and their overlap information. Some tools such as [Bandage](http://rrwick.github.io/Bandage/) allow to visualize the assembly graph.
> > - The fourth dataset is a tabular file (assembly_info) containing extra information about contigs/scaffolds.
> >
> {: .solution}
>
{: .question}
  
</div>

# Quality assessment

## Genome assemblies comparison with **Quast**

A way to calculate metrics assembly is to use ***QUAST = QUality ASsessment Tool***. Quast is a tool to evaluate genome assemblies by computing various metrics. The manual of Quast is here: [Quast](http://quast.sourceforge.net/docs/manual.html#sec3)

> <hands-on-title>Quast</hands-on-title>
>
> 1. {% tool [Quast](toolshed.g2.bx.psu.edu/repos/iuc/quast/quast/5.0.2+galaxy3) %} with the following parameters:
>    - *"Use customized names for the input files?"*: `No, use dataset names`
>        - {% icon param-file %} *"Contigs/scaffolds file"*: `JBKZXA01.fasta.gz` (reference assembly), `fasta file` (output of **GFA to FASTA** {% icon tool %}) and/or `consensus` (output of **Flye** {% icon tool %})
>    - *"Type of assembly"*: `Genome`
>        - *"Type of organism"*: `Fungus: use of GeneMark-ES for gene finding, ...`
>
{: .hands_on}

> <question-title></question-title>
>
> 1. Compare the different metrics obtained for the assembly you generated and the reference genome.
> 2. What can you conclude about the quality of this new assembly ?
>
> > <solution-title></solution-title>
> >
> > 1. We compare the metrics of the three assemblies:
> > - TO DO The reference genome: 24 contigs, 16 scaffolds, Contig N50 = 4.3Mb, Contig length max = 6.2 Mb, size = 106 Mb, 74.27% GC
> > - TO DO The Hifiasm assembly: 105 contigs/scaffolds, N50 = 4.9 Mb, length max = 7.1Mb, assembly size = 42.1 Mb, 47.91% GC
> > - TO DO The Flye assembly: 13 contigs/scaffolds, N50 = 4.9Mb, length max = 6.8Mb, size = 38.7 Mb, 49.31% GC
> > 2. TO DO Metrics are very similar, Flye generated an assembly with a quality similar to that of the reference genome.
> >
> {: .solution}
>
{: .question}

## Genome assembly assessment with **BUSCO**

***BUSCO (Benchmarking Universal Single-Copy Orthologs)*** allows a measure for quantitative assessment of genome assembly based on evolutionarily informed expectations of gene content. Details for this tool are here: [Busco website](https://busco.ezlab.org/)

> <hands-on-title>BUSCO on assembly</hands-on-title>
>
> 1. {% tool [Busco](toolshed.g2.bx.psu.edu/repos/iuc/busco/busco/5.2.2+galaxy0) %} with the following parameters:
>    - *"Tool version"*: `Galaxy Version 5.8.0+galaxy0`
>    - {% icon param-file %} *"Sequences to analyse"*: Multiple datasets
>    - {% icon param-file %} *"Sequences to analyse"*: `JBKZXA01.fasta.gz` (reference assembly), `fasta file` (output of **GFA to FASTA** {% icon tool %}) and/or `consensus` (output of **Flye** {% icon tool %})
>    - *"Auto-detect or select lineage"*: `Select lineage` - Not working on April 16 2025
>        - *"Lineage"*: `Fungi`
>        - *"Which outputs should be generated"*: `short summary text; summary image`
{: .hands_on}

> <question-title></question-title>
>
> Compare the number of BUSCO genes identified in the generated assembly and the reference genome. What do you observe ?
>
> > <solution-title></solution-title>
> >
> > Short summary generated by BUSCO indicates that reference genome contains:
> > 1. TO DO 2327 Complete BUSCOs (of which 2302 are single-copy and 25 are duplicated),
> > 2. TO DO 13 fragmented BUSCOs,
> > 3. TO DO 109 missing BUSCOs.
> >
> > Short summary generated by BUSCO indicates that Hifiasm assembly contains:
> > 1. 756 complete BUSCOs (754 single-copy and 2 duplicated),
> > 2. 0 fragmented BUSCOs
> > 3. 2 missing BUSCOs.
> >
> > Short summary generated by BUSCO indicates that Flye assembly contains:
> > 1. 755 complete BUSCOs (753 single-copy and 2 duplicated),
> > 2. 0 fragmented BUSCOs
> > 3. 3 missing BUSCOs.
> >
> > BUSCO analysis confirms that these two assemblies are of similar quality, with similar number of complete, fragmented and missing BUSCOs genes.
> >
> {: .solution}
>
{: .question}



# Conclusion


This pipeline shows how to generate and evaluate a genome assembly from long reads PacBio data. Once you are satisfied with your genome sequence, you might want to annotate it: have a look at the [RepeatMasker]({% link topics/genome-annotation/tutorials/repeatmasker/tutorial.md %}) and [Funannoate]({% link topics/genome-annotation/tutorials/funannotate/tutorial.md %}) tutorials to learn how to do it!
