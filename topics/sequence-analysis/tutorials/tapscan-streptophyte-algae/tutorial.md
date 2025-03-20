---
layout: tutorial_hands_on

title: Identification and Evolutionary Analysis of Transcription-Associated Proteins
  in Streptophyte algae and Land plants
zenodo_link: ''
questions:
- What are transcription-associated proteins (TAPs)?
- How can we identify TAPs from a given proteome dataset?
- How do we construct a phylogenetic tree for TAPs?
objectives:
- Understand the role of TAPs
- Learn how to identify TAPs from a given proteome using TAPScan
- Extract FASTA sequences using sequence ID/header
- Perform sequence alignment and construct phylogenetic tree for TAPs
- Interpret evolutionary relatationship among TAPs
time_estimation: 2H
key_points:
- TAPScan v4 is a comprehensive and highly reliable tool for genome-wide TAP annotation via domain profiles
contributions:
  authorship:
    - deeptivarshney
    - shiltemann

  funding:
    - madland

tags:
  - plants

---


# Introduction

<!-- This is a comment. -->
The regulated expression of genes is essential for defining morphology, functional capacity, and developmental fate of both solitary living cells as well as cells inhabiting the social environment of a multicellular organism. In this regard, the regulation of transcription, that is, the synthesis of messenger RNA from a genomic DNA template, plays a crucial role. It contributes to the control of temporal and spatial RNA and protein levels in a cell and therefore has an essential function in all living organisms. Transcription‐associated proteins (TAPs) are essential players in gene regulatory networks (GRNs) as they involved in transcriptional regulation. TAPs are broadly classified into transcription factors (TFs) and transcriptional regulators (TRs). TFs bind sequence‐specifically to regulatory elements, resulting in enhancing or repressing of transcription ({% cite Richardt2007 %}; {% cite Wilhelmsson2017 %}). TRs, on the other hand, are involved in protein–protein interactions, may serve as regulators at the transcriptional core complex, as co‐activators and co‐repressors, chromatin modification or methylation. Additionally, there are proteins referred to as putative TAPs (PTs) that are thought to be involved in the regulation of transcription, but their exact function is undefined ({% cite Richardt2007 %}).

TAPScan v4 ({% cite Petroll2024 %}) is a comprehensive tool for annotating TAPs with a special focus on species belonging to the Archaeplastida. In general, the detection of TAPs is based on the detection of highly conserved protein domains.

In this tutorial, we will illustrate the identification of TAPs in streptophyte algae and land plants using [TAPScan Classify](https://github.com/Rensing-Lab/TAPscan-classify), followed by construction of the phylogenetic tree.


> <agenda-title></agenda-title>
>
> In this tutorial, we will cover:
>
> 1. TOC
> {:toc}
>
{: .agenda}

## Get data

In this tutorial, we will use representative protein sequences obtained from the [Genome Zoo database](https://github.com/Rensing-Lab/Genome-Zoo). The selected sequences represent different lineages:

**Streptophyte Algae:**
- *Chara braunii* (CHABR)
- *Penium margaritaceum* (PENMA)

**Bryophytes & Land Plants**
- *Marchantia polymorpha* (MARPO)
- *Physcomitrium patens* (PHYPAV6)
- *Oryza sativa (spp. japonica)* (ORYSAJA)
- *Selaginella moellendorffii* (SALMO)
- *Arabidopsis thaliana* (ARATH)


> <hands-on-title> Data Upload </hands-on-title>
>
> 1. Create a new history for this tutorial and give it a proper name
>
>    {% snippet faqs/galaxy/histories_create_new.md %}
>
> 2. Rename the history
>
>    {% snippet faqs/galaxy/histories_rename.md %}
>
>
{: .hands_on}

Now, we need to import the data

> <hands-on-title>Import datasets</hands-on-title>
>
> 1. Import the following from [Zenodo]({{ page.zenodo_link }}) or from
>    the shared data library:
>
>    ```
>   https://zenodo.org/records/15056031/files/ARATH.fa
>   https://zenodo.org/records/15056031/files/CHABR.fa
>   https://zenodo.org/records/15056031/files/MARPO.fa
>   https://zenodo.org/records/15056031/files/PENMA.fa
>   https://zenodo.org/records/15056031/files/SALMO.fa
>   https://zenodo.org/records/15056031/files/PHYPAV6.fa
>   https://zenodo.org/records/15056031/files/ORYSAJA.fa
>  ```
>
>    {% snippet faqs/galaxy/datasets_import_via_link.md %}
>
>    {% snippet faqs/galaxy/datasets_import_from_data_library.md %}
>
> 3. Create a dataset collection
>
>    {% snippet faqs/galaxy/collections_build_list.md %}
>
{: .hands_on}

If you were successful, all the input files should now be available as dataset collection in your history.

# Identification of TAPs

In order to detect TAPs from the given proteome(s), each sequence out of a species protein set is first scanned for protein domains (stored as profile Hidden Markov Models) using hmmsearch. The domains list consists of 154 profile HMMs and functions as the domain reference during the hmmsearch in background.

Afterwards, [TAPScan Classify](https://github.com/Rensing-Lab/TAPscan-classify) applies specialized rules to assign the protein sequences, scanned for 137 different TAP families, ensuring accurate family assignment using GA-thresholds and coverage values.

## TAPScan Classify

Now that our dataset collection is ready, we can run [TAPScan Classify](https://github.com/Rensing-Lab/TAPscan-classify) to detect TAPs in all species.

> <hands-on-title> Detect TAPs </hands-on-title>
>
> 1. {% tool [TAPScan Classify](toolshed.g2.bx.psu.edu/repos/bgruening/tapscan/tapscan_classify/4.76+galaxy0) %} with the following parameters:
>    - {% icon param-collection %} *"Proteins in FASTA format"*: `output` (Input dataset collection)
>
>    > <comment-title> on parameter </comment-title>
>    >
>    > If you would like to have Output table from the HMMer Search, Please Check on the box like below:
>    - *"Output the HMMer domain hits table?"*: `Yes`
>    {: .comment}
>
>
{: .hands_on}

TAPScan Classify provides the user with three different output files. Each output file is tab-separated.

- **Output 1: "Detected TAPs"** - contains the detected domains and finally assigned TAP family for each gene ID. If domains are assigned to a sequence but not all rules are fulfilled, the sequence is assigned to *“0_no_family_found”*.
- **Output 2: "Family Counts"** - is a summary of the number of members for each TAP family.
- **Output 3: "Detected TAPs Extra"** - is similar to output 1 but contains additional information.


> <question-title></question-title>
>
> 1. What is the output format of TAPScan Classify?
> 2. How many sequences belong to the “0_no_family_found” in *Arabidopsis thaliana* (ARATH) ?
> 3. What extra information does Output 3 include compared to Output 1?
>
> > <solution-title></solution-title>
> >
> > 1. Tabular
>   2. 675, You can find this number by clicking on the eye button for Galaxy dataset output 2 for ARATH.
> > 3. Output 3 contains information about subfamilies with an additional column that provides more details beyond what is included in Output 1.
> > 
> >
> {: .solution}
>
{: .question}

> <hands-on-title> Filter the TAPScan output Based on the Column  </hands-on-title>
>
> 1. {% tool [Filter](Filter1) %} with the following parameters:
>    - {% icon param-file %} *"Filter"*: `taps_detected` (output of **TAPScan Classify** {% icon tool %})
>    - *"With following condition"*: `c2=='Aux/IAA'`
>    - *"Number of header lines to skip"*: `1`
>
>    > <comment-title> What's happening in this section? </comment-title>
>    >
>    > This step filters the TAPScan results to retain only sequences classified as belonging to the our desired (Aux/IAA) TAP family.
>    {: .comment}
>    > <question-title></question-title>
>    >
>    > How many sequences belong to the 'Aux/IAA' TAP family in *Arabidopsis thaliana* (ARATH), excluding the header line?
>    >
>    > > <solution-title></solution-title>
>    > > 29, You can find this number by expanding the Galaxy dataset output for ARATH.
>    > {: .solution}
>    >
>    {: .question}
>
{: .hands_on}


> <hands-on-title> Cut the column </hands-on-title>
>
> 1. {% tool [Cut](Cut1) %} with the following parameters:
>    - *"Cut columns"*: `c1`
>    - {% icon param-file %} *"From"*: `out_file1` (output of **Filter** {% icon tool %})
>
>    > <comment-title> short description </comment-title>
>    >
>    > We need to extract the column that contains the sequence ID, which will be used to extract the FASTA sequences in further analysis
>    {: .comment}
>
{: .hands_on}

Before moving to the step for extracting the FASTA sequences, we need to remove the header line.

> <hands-on-title> Remove header line </hands-on-title>
>
> 1. {% tool [Remove beginning](Remove beginning1) %} with the following parameters:
>
>    - *"Remove first\*"*: `1`
>    - {% icon param-file %} *"from"*: `out_file1` (output of **Cut** {% icon tool %})
>
>
{: .hands_on}



## Extract the sequences for TAP families

> <hands-on-title> Extract the FASTA sequences </hands-on-title>
>
> 1. {% tool [Filter FASTA](toolshed.g2.bx.psu.edu/repos/galaxyp/filter_by_fasta_ids/filter_by_fasta_ids/2.3) %} with the following parameters:
>    - {% icon param-collection %} *"FASTA sequences"*: `output` (Input dataset collection)
>    - *"Criteria for filtering on the headers"*: `List of IDs`
>        - {% icon param-file %} *"List of IDs to extract sequences for"*: `out_file1` (output of **Remove beginning** {% icon tool %})
>        - *"Match IDs by"*: `Default: ID is expected at the beginning: >ID `
>
> 
>    > <question-title></question-title>
>    >
>    > 1. What if my IDs don't match?
>    >
>    > > <solution-title></solution-title>
>    > > 1. If your FASTA file includes additional annotations in the headers, you may need to preprocess your ID list or modify the matching criteria.
>    > {: .solution}
>    >
>    {: .question}
>

{: .hands_on}


# Evolutionary Analysis

Now that we have identified TAP families of interest across multiple species, let's perform an evolutionary analysis.


TODO: CYOA for full workflows (with pairwise step) or individual steps?




## Multiple Sequence Alignment (MSA)

First, we will perform a multiple sequence alignment in order to determine the similarity between all sequences in our TAP family.


> <hands-on-title> MSA of our protein sequences </hands-on-title>
>
> 1. {% tool [MAFFT](toolshed.g2.bx.psu.edu/repos/rnateam/mafft/rbc_mafft/7.526+galaxy1) %} with the following parameters:
>    - *"For multiple inputs generate"*: `a single MSA of all sequences from all inputs`
>        - In *"Input batch"*:
>            - {% icon param-repeat %} *"Insert Input batch"*
>                - {% icon param-collection %} *"Sequences to align"*: the collection of FASTA files from our TAP families (output of **Filter FASTA** {% icon tool %})
>    - *"Type of Sequences"*: Amino Acids
>    - *"Configure Gap Costs"*: Set values
>      - *"Gap extension penalty for group-to-group alignment "*: `0.0`
>    - *"Support unusual characters?"*: `Yes`
>    - *"MAFFT flavour"*: `Auto`
>    - *"Reorder output"*: `Yes`
>
>    > <question-title></question-title>
>    >
>    > 1. How many sequences do we have in total?
>    >
>    > > <solution-title></solution-title>
>    > > 1. 85 sequences. You can find this number by expanding the Galaxy dataset output from MAFFT.
>    > {: .solution}
>    >
>    {: .question}
>
{: .hands_on}


Let's have a look at the output file generated by MAFFT

you will see something like:

```
>3702.ARATH_AT2G46990.1
----------------------MGRG-------------------------RSSSSSSIE
S-----------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
[..]
>3702.ARATH_AT3G62100.1
----------------------MGRG-------------------------RSSSSSSIE
S-----------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
--------------------------SCKSN-----------------------------
----------------------------------------PFGVSSSNTRNL--------
--------------------STD-------------------------------------
[..]
>3702.ARATH_AT3G17600.1
----------------------------------------------------MEVSNSCS
SFS---------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
[..]
```


> <question-title> What's in an alignment? </question-title>
>
> 1. What is in the this file?
> 2. What do the dashes signify?
>
> > <solution-title></solution-title>
> >
> > 1. This file conatains a single alignment of all sequences. This format is similar to a FASTA file, but contains additional characters (e.g. dashes (`-`)
> > 2. Dashes indicate a gap in the alignment at that position for the sequence in question
> {: .solution}
>
{: .question}


A nicer way to look at this output, is in the MSA viewer that is built into Galaxy.

> <hands-on-title> Visualise our Multiple Sequence Alignment </hands-on-title>
>
> 1. Click on the MAFFT output to expand it in your history
> 2. Click on the {% icon galaxy-visualise %} **Visualize** button
> 3. In the main window, pick the "Multiple Sequence Alignment" option
>    ![button to click to select the MSA visualisation option]({% link topics/sequence-analysis/tutorials/tapscan-streptophyte-algae/images/visualize-msa-galaxy.png %})
> 4. You should see a visual representation of you MSA
>    ![screenshot of the multiple sequence alignment]({% link topics/sequence-analysis/tutorials/tapscan-streptophyte-algae/images/visualize-msa-screenshot.png %})
{: .hands_on}



> <question-title> Alignment visualisation </question-title>
>
> 1. What do you see?
> 2. How long is the total alignment?
>
> > <solution-title></solution-title>
> >
> > 1. You see every sequence in your dataset aligned together. On the left you see the read IDs. You can scroll down here to see more. On the top you see the position in the alignment. You can scroll left and right here to view different parts of the alignment. Where amino acids align, you will see a colored square and the letter indicating the amino acid. Where there is a gap, you will see a dash (`-`). At the top, you will also see a histogram indicating how many sequences align at that position.
> > 2. If you scroll all the way right in the aligment viewer, you will see a total length of 8182 amino acids
> {: .solution}
>
{: .question}


TODO: is there a region in alignment viewer that we can highlight that shows the need for the next trimming step?



## Alignment trimming


Next, we would like to clean up this alignment by e.g. removing spurious sequences or poorly aligned regions from our multiple sequence alignment. {% icon tool %} **TrimAl** is a tool that can do this


> <hands-on-title> Clean up our alignment </hands-on-title>
>
> 1. {% tool [trimAl](toolshed.g2.bx.psu.edu/repos/iuc/trimal/trimal/1.5.0+galaxy1) %} with the following parameters:
>    - {% icon param-file %} *"Alignment file"*: output of **MAFFT** {% icon tool %})
>    - *"Select trimming mode from the list"*: `custom mode`
>      - *"Gap threshold"*: 0.5
>      - *"Similarity Threshold"* 0.001
>
> > <question-title></question-title>
> > 1. How many sequences were removed in this trimming step?
> >
> > > <solution-title></solution-title>
> > > 1. 126 sequences. Recall that we had 667 sequences at the start. Expanding the Trimmed Alignment output from TrimAl, we see that we now have 541 sequences. 667-541=126.
> > {: .solution}
> >
> {: .question}
>
{: .hands_on}

Examine {% icon galaxy-eye %} the **HTML report output from Trimal** (you may have to click "Show All" at the top of the box first)

![screenshot of TrimAl output]({% link topics/sequence-analysis/tutorials/tapscan-streptophyte-algae/images/trimal-screenshot.png %})





## Tree Generation


TODO: some background about NJ vs ML trees

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Quicktree](toolshed.g2.bx.psu.edu/repos/iuc/quicktree/quicktree/2.5+galaxy0) %} with the following parameters:
>    - *"Provide an alignment file or a distance matrix?"*: `Alignment File`
>        - {% icon param-file %} *"Alignment file"*: `trimmed_output` (output of **trimAl** {% icon tool %})
>    - *"Calcuate bootstrap values with n iterations"*: `100`
>
> 2. Expand the output of Quicktree, and click on the {% icon galaxy-visualize %} visualise button
>    - click on "Phylogenetic Tree Visualization"
>
>    - You should see a tree like
>      ![tree visualized with built-in tree viewer](./images/tree-viz-galaxy.png)
{: .hands_on}


TODO: see how long IQ-tree takes and decide whether to keep it, since it is much slower

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [IQ-TREE](toolshed.g2.bx.psu.edu/repos/iuc/iqtree/iqtree/2.3.6+galaxy0) %} with the following parameters:
>    - In *"General options"*:
>        - {% icon param-file %} *"Specify input alignment file in PHYLIP, FASTA, NEXUS, CLUSTAL or MSF format."*: `trimmed_output` (output of **trimAl** {% icon tool %})
>        - *"Specify sequence type as either of DNA, AA, BIN, MORPH, CODON or NT2AA for DNA, amino-acid, binary, morphological, codon or DNA-to-AA-translated sequences"*: `AA`
>    - In *"Time Tree Reconstruction"*:
>        - *"Source of date information"*: `Skip time tree reconstruction`
>    - In *"Modelling Parameters"*:
>        - In *"Automatic model selection"*:
>            - *"Do you want to use a custom model"*: `Yes, I want to use a custom model`
>                - *"Model"*: `MFP`
>            - *"Merge partitions"*: `Do not merge`
>        - In *"Partition model options"*:
>            - *"Partition model"*: `No partition model`
>    - In *"Tree Parameters"*:
>        - In *"Single branch tests"*:
>            - *"Specify number of replicates (>=1000) to perform SH-like approximate likelihood ratio test (SH-aLRT) (Guindon et al., 2010)"*: `1000`
>    - In *"Bootstrap Parameters"*:
>        - In *"Ultrafast bootstrap parameters"*:
>            - *"Specify number of bootstrap replicates (>=1000)."*: `1000`
>
{: .hands_on}


## Tree Visualisation

We already had a look at the tree using Galaxy's built-in tree viewer, but sometimes it is nicer to look at with other tools.
For example, the [Phylogenetic Tree Viewer from ETE Toolkit](https://etetoolkit.org/treeview/). You could download your tree
to your machine, and upload it to ETE toolkit, but you can also do this directly within Galaxy!

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [ETE tree viewer](toolshed.g2.bx.psu.edu/repos/iuc/ete_treeviewer/ete_treeviewer/3.1.3+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Newick Tree to visualise"*: `output` (output of **Text transformation** {% icon tool %})
>    - *"Add alignment information to image?"*: `yes`
>        - {% icon param-file %} *"Multiple Alignment FASTA file"*: `output` (output of **Text transformation** {% icon tool %})
>    - *"Resolve Taxonomic IDs?"*: Yes
>    - *"Format of the output image."*: `PNG`
>
> 2. *Examine* {% icon galaxy-eye %} the output image
>
{: .hands_on}

You should see a tree image like this:

![tree visualisation by ETE toolkit](./images/tree-viz-ete.png)


As you can see, in addition to the tree itself, this also contains a visualisation of the alignments, and the taxonomy.

> <details-title>Where did the taxonomy information come from?</details-title>
> Note that ETE toolkit will display this taxonomy based on your FASTA headers.
> If your sequence names start with the NCBI TaxID followed by a period, ETE
> TreeViewer will display them.
>
> For example, here are the headers in our file:
>
> ```
> >88036.SELMO_e_gw1.105.41.1
> -----------MNELLRLMPRDASIIGAIFVKLELLQL-V
> >88036.SELMO_fgenesh2_pg.C_scaffold_136000057
> GPS-KERRRKQMNELLRLMPRDASIIGAIFVKLELLQLSI
> ```
> where `88036` is the NCBI TaxID for Selaginella moellendortffii
>
{: .details}




TODO: exercise to repeat on other trees? anything we can see from the differences between the different trees?


## Repeating analysis on your own data

TODO: Provide full gene family tree workflow and show how to use

# Conclusion

Sum up the tutorial and the key takeaways here. We encourage adding an overview image of the
pipeline used.
