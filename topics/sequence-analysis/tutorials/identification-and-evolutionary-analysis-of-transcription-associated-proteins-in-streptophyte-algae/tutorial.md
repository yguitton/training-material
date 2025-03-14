---
layout: tutorial_hands_on

title: Identification and Evolutionary Analysis of Transcription-Associated Proteins
  in Streptophyte Algae
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
time_estimation: 3H
key_points:
- TAPscan v4 is a comprehensive and highly reliable tool for genome-wide TAP annotation via domain profiles
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
The regulated expression of genes is essential for defining morphology, functional capacity, and developmental fate of both solitary living cells as well as cells inhabiting the social environment of a multicellular organism. In this regard, the regulation of transcription, that is, the synthesis of messenger RNA from a genomic DNA template, plays a crucial role. It contributes to the control of temporal and spatial RNA and protein levels in a cell and therefore has an essential function in all living organisms.

Transcription‐associated proteins (TAPs) are essential players in gene regulatory networks (GRNs) as they involved in transcriptional regulation. TAPs are broadly classified into transcription factors (TFs) and transcriptional regulators (TRs). TFs bind sequence‐specifically to regulatory elements, resulting in enhancing or repressing of transcription ({% cite Richardt2007 %}; {% cite Wilhelmsson2017 %}). TRs, on the other hand, are involved in protein–protein interactions, may serve as regulators at the transcriptional core complex, as co‐activators and co‐repressors, chromatin modification or methylation. Additionally, there are proteins referred to as putative TAPs (PTs) that are thought to be involved in the regulation of transcription, but their exact function is undefined ({% cite Richardt2007 %}).

[TAPScan Classify](https://github.com/Rensing-Lab/TAPscan-classify) is a comprehensive tool for annotating TAPs with a special focus on species belonging to the Archaeplastida. In general, the detection of TAPs is based on the detection of highly conserved protein domains.

In this tutorial, we will illustrate the identification of TAPs in Streptophyte algae and land plants using [TAPScan Classify](https://github.com/Rensing-Lab/TAPscan-classify), followed by construction of the phylogenetic tree.


> <agenda-title></agenda-title>
>
> In this tutorial, we will cover:
>
> 1. TOC
> {:toc}
>
{: .agenda}

# Get data

In this tutorial, we will use representative protein sequences obtained from the [Genome Zoo database](https://github.com/Rensing-Lab/Genome-Zoo). The selected sequences represent different plant lineages:

**Streptophyte Algae:**
- Chara braunii (CHABR)
- Klebsormidium nitens (KLEFL)
- Chlorokybus atmophyticus (CHLAT)
- Mesotaenium endlicherianum (MESEN)
- Penium margaritaceum (PENMA)

**Bryophytes:**
- Marchantia polymorpha (MARPO)
- Physcomitrium patens (PHYPAV6)

**Vascular Plants:**
- Oryza sativa (spp. japonica) (ORYSAJA)
- Arabidopsis thaliana (ARATH)

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

{: .hands_on}

Now, we need to import the data

> <hands-on-title>Import datasets</hands-on-title>
>
> 1. Import the following from [Zenodo]({{ page.zenodo_link }}) or from
>    the shared data library (`GTN - Material` -> `{{ page.topic_name }}`
>     -> `{{ page.title }}`):
>
>    ```
>
>    ```
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

In order to detect TAPs from the given proteome(s), each sequence out of a species protein set is first scanned for protein domains (stored as profile Hidden Markov Models) using hmmsearch. The domains list consists of 154 profile HMMs and functions as the domain reference during the hmmsearch command.

Afterwards, by running [TAPScan Classify](https://github.com/Rensing-Lab/TAPscan-classify), specialized rules are applied to finally assign the protein sequences to TAP families based on the detected domains in the previous step. With the latest TAPscan v4 ({% cite Petroll2024 %}), a protein set can be scanned for 137 different TAP families with high accuracy through applying GA-thresholds and coverage values.


## **TAPScan Classify**

Now that our dataset collection is ready, we can proceed to run [TAPScan Classify](https://github.com/Rensing-Lab/TAPscan-classify) to identify TAPs.

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

TAPscan provides the user with three different output files. Each output file is tab-separated.

- **Output 1: "Detected TAPs"** - contains the detected domains and finally assigned TAP family for each gene ID. If domains are assigned to a sequence but not all rules are fulfilled, the sequence is assigned to *“0_no_family_found”*.
- **Output 2: "Family Counts"** - is a summary of the number of members for each TAP family.
- **Output 3: "Detected TAPs Extra"** - is similar to output 1 but contains additional information about subfamilies.


## Sub-step with **Filter**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Filter](Filter1) %} with the following parameters:
>    - {% icon param-file %} *"Filter"*: `taps_detected` (output of **TAPScan Classify** {% icon tool %})
>    - *"With following condition"*: `c2=='bHLH'`
>    - *"Number of header lines to skip"*: `1`
>
>    > <comment-title> What's happening in this section? </comment-title>
>    >
>    > This step filters the TAPScan results to retain only sequences classified as belonging to the our desired TAP family. This allows us to focus on a specific group of TAPs for further analysis.
>    {: .comment}
>
{: .hands_on}

***TODO***: *Consider adding a question to test the learners understanding of the previous exercise*

> <question-title></question-title>
>
> 1. Question1?
> 2. Question2?
>
> > <solution-title></solution-title>
> >
> > 1. Answer for question1
> > 2. Answer for question2
> >
> {: .solution}
>
{: .question}

## Sub-step with **Cut**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Cut](Cut1) %} with the following parameters:
>    - *"Cut columns"*: `c1`
>    - {% icon param-file %} *"From"*: `out_file1` (output of **Filter** {% icon tool %})
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

***TODO***: *Consider adding a question to test the learners understanding of the previous exercise*

> <question-title></question-title>
>
> 1. Question1?
> 2. Question2?
>
> > <solution-title></solution-title>
> >
> > 1. Answer for question1
> > 2. Answer for question2
> >
> {: .solution}
>
{: .question}

## Sub-step with **Remove beginning**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Remove beginning](Remove beginning1) %} with the following parameters:
>    - {% icon param-file %} *"from"*: `out_file1` (output of **Cut** {% icon tool %})
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

***TODO***: *Consider adding a question to test the learners understanding of the previous exercise*

> <question-title></question-title>
>
> 1. Question1?
> 2. Question2?
>
> > <solution-title></solution-title>
> >
> > 1. Answer for question1
> > 2. Answer for question2
> >
> {: .solution}
>
{: .question}

## Sub-step with **Filter FASTA**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Filter FASTA](toolshed.g2.bx.psu.edu/repos/galaxyp/filter_by_fasta_ids/filter_by_fasta_ids/2.3) %} with the following parameters:
>    - {% icon param-collection %} *"FASTA sequences"*: `output` (Input dataset collection)
>    - *"Criteria for filtering on the headers"*: `List of IDs`
>        - {% icon param-file %} *"List of IDs to extract sequences for"*: `out_file1` (output of **Remove beginning** {% icon tool %})
>        - *"Match IDs by"*: `Default: ID is expected at the beginning: >ID `
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

***TODO***: *Consider adding a question to test the learners understanding of the previous exercise*

> <question-title></question-title>
>
> 1. Question1?
> 2. Question2?
>
> > <solution-title></solution-title>
> >
> > 1. Answer for question1
> > 2. Answer for question2
> >
> {: .solution}
>
{: .question}



# Evolutionary Analysis

Now that we have identified TAP families of interest across multiple species, let's perform an evolutionary analysis.

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [MAFFT](toolshed.g2.bx.psu.edu/repos/rnateam/mafft/rbc_mafft/7.526+galaxy1) %} with the following parameters:
>    - *"For multiple inputs generate"*: `a single MSA of all sequences from all inputs`
>        - In *"Input batch"*:
>            - {% icon param-repeat %} *"Insert Input batch"*
>                - {% icon param-file %} *"Sequences to align"*: `data_param` (output of **Pick parameter value** {% icon tool %})
>    - *"Type of sequences"*: `Amino acids`
>        - *"Type of scoring matrix"*: `BLOSUM`
>        - *"Configure gap costs"*: `Set values`
>    - *"Support unusual characters?"*: `Yes`
>    - *"MAFFT flavour"*: `Auto`
>    - *"Reorder output?"*: `Yes`
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

***TODO***: *Consider adding a question to test the learners understanding of the previous exercise*

> <question-title></question-title>
>
> 1. Question1?
> 2. Question2?
>
> > <solution-title></solution-title>
> >
> > 1. Answer for question1
> > 2. Answer for question2
> >
> {: .solution}
>
{: .question}

## Sub-step with **trimAl**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [trimAl](toolshed.g2.bx.psu.edu/repos/iuc/trimal/trimal/1.5.0+galaxy1) %} with the following parameters:
>    - {% icon param-file %} *"Alignment file (clustal, fasta, NBRF/PIR, nexus, phylip3.2, phylip)"*: `outputAlignment` (output of **MAFFT** {% icon tool %})
>    - *"Select trimming mode from the list"*: `custom mode - define trimming parameters yourself.`
>        - *"Gap threshold"*: `0.5`
>        - *"Similarity threshold"*: `0.001`
>        - *"Minimum conservance percentage"*: `0`
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

***TODO***: *Consider adding a question to test the learners understanding of the previous exercise*

> <question-title></question-title>
>
> 1. Question1?
> 2. Question2?
>
> > <solution-title></solution-title>
> >
> > 1. Answer for question1
> > 2. Answer for question2
> >
> {: .solution}
>
{: .question}

## Sub-step with **Quicktree**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Quicktree](toolshed.g2.bx.psu.edu/repos/iuc/quicktree/quicktree/2.5+galaxy0) %} with the following parameters:
>    - *"Provide an alignment file or a distance matrix?"*: `Alignment File`
>        - {% icon param-file %} *"Alignment file"*: `trimmed_output` (output of **trimAl** {% icon tool %})
>    - *"Calcuate bootstrap values with n iterations"*: `1000`
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

***TODO***: *Consider adding a question to test the learners understanding of the previous exercise*

> <question-title></question-title>
>
> 1. Question1?
> 2. Question2?
>
> > <solution-title></solution-title>
> >
> > 1. Answer for question1
> > 2. Answer for question2
> >
> {: .solution}
>
{: .question}

## Sub-step with **IQ-TREE**

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

***TODO***: *Consider adding a question to test the learners understanding of the previous exercise*

> <question-title></question-title>
>
> 1. Question1?
> 2. Question2?
>
> > <solution-title></solution-title>
> >
> > 1. Answer for question1
> > 2. Answer for question2
> >
> {: .solution}
>
{: .question}


## Sub-step with **ETE tree viewer**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [ETE tree viewer](toolshed.g2.bx.psu.edu/repos/iuc/ete_treeviewer/ete_treeviewer/3.1.3+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Newick Tree to visualise"*: `output` (output of **Text transformation** {% icon tool %})
>    - *"Add alignment information to image?"*: `yes`
>        - {% icon param-file %} *"Multiple Alignment FASTA file"*: `output` (output of **Text transformation** {% icon tool %})
>    - *"Format of the output image."*: `PNG`
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

***TODO***: *Consider adding a question to test the learners understanding of the previous exercise*

> <question-title></question-title>
>
> 1. Question1?
> 2. Question2?
>
> > <solution-title></solution-title>
> >
> > 1. Answer for question1
> > 2. Answer for question2
> >
> {: .solution}
>
{: .question}

## Sub-step with **ETE tree viewer**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [ETE tree viewer](toolshed.g2.bx.psu.edu/repos/iuc/ete_treeviewer/ete_treeviewer/3.1.3+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Newick Tree to visualise"*: `output` (output of **Text transformation** {% icon tool %})
>    - *"Add alignment information to image?"*: `yes`
>        - {% icon param-file %} *"Multiple Alignment FASTA file"*: `output` (output of **Text transformation** {% icon tool %})
>    - *"Format of the output image."*: `PNG`
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

***TODO***: *Consider adding a question to test the learners understanding of the previous exercise*

> <question-title></question-title>
>
> 1. Question1?
> 2. Question2?
>
> > <solution-title></solution-title>
> >
> > 1. Answer for question1
> > 2. Answer for question2
> >
> {: .solution}
>
{: .question}

## Sub-step with **ETE tree viewer**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [ETE tree viewer](toolshed.g2.bx.psu.edu/repos/iuc/ete_treeviewer/ete_treeviewer/3.1.3+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Newick Tree to visualise"*: `output` (output of **Text transformation** {% icon tool %})
>    - *"Add alignment information to image?"*: `yes`
>        - {% icon param-file %} *"Multiple Alignment FASTA file"*: `output` (output of **Text transformation** {% icon tool %})
>    - *"Format of the output image."*: `PNG`
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

***TODO***: *Consider adding a question to test the learners understanding of the previous exercise*

> <question-title></question-title>
>
> 1. Question1?
> 2. Question2?
>
> > <solution-title></solution-title>
> >
> > 1. Answer for question1
> > 2. Answer for question2
> >
> {: .solution}
>
{: .question}


## Re-arrange

To create the template, each step of the workflow had its own subsection.

***TODO***: *Re-arrange the generated subsections into sections or other subsections.
Consider merging some hands-on boxes to have a meaningful flow of the analyses*





# Conclusion

Sum up the tutorial and the key takeaways here. We encourage adding an overview image of the
pipeline used.
