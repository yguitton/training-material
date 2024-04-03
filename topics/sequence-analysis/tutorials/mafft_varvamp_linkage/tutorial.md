---
layout: tutorial_hands_on

title: Primer design of related virus genome sequences
level: Introductory
zenodo_link: ''
questions:
- How can primers for related viruses of a pool of different virus genomes for further PCR be obtained?
- What kind of different multiple sequence alignment methods can be used to analyze my virus genome data?
- How can the primer design be adjusted, to get the best fitting primers for further sequencing?
- How can I avoid generating primers for off-targets?
    
objectives:
- Run the workflow to summarize and analyse related virus genomes with different alignment methods in a sample batch
- Run the workflow to generate primers for different sequencing techniques

time_estimation: 1H
key_points:
- alignment of genome data with MAFFT
- after aligning, you can design primers of any viral genome data with VarVAMP
- build a BLAST database and use it in combination with VarVAMP
requirements:
-
    type: "internal"
    topic_name: galaxy-interface
    tutorials:
        - 
contributors:
- elischberg
- wm75
tags:
- virology
---


For studying viruses it is necessary to have the option to sequence and reproduce the viral genomes in specific parts or as a whole. Multiple alignment sequencing makes it possible to search for relation of viral genomes in datasets of samples and helps to isolate single families. In order to multiply these related gene sequences, a new tool named VarVAMP, assists in designing primers with high reproducibilty for further sequencing, such as PCR or Next Generation Sequencing.

This training shows the application and understanding of the tools MAFFT, a multifunctional alignment tool for nucleic and amino acid sequences, and VarVAMP, a primer design tool for viruses with a broad functionality in terms of tool adjustements or different types of output generation. The combination of these two provides a automation of finding related virus sequences in data with producing fitting primers for amplification. The data we use for this tutorial are Polio 1-3 genomes, provided by [Jonas Fuchs](https://github.com/jonas-fuchs/ViralPrimerSchemes/tree/main). We'll control our soon designed primers with the primer schemes on this Website, to show the reproducibility of varvamp, as one of its strongest points.


{% raw %} `{% cite Batut2018 %}`{% endraw %}.

> <agenda-title></agenda-title>
>
> In this tutorial, we will cover:
>
> 1. TOC
> {:toc}
>
{: .agenda}

# Data and Galaxy preparation

First of all, it is important to get your settings and data right.

## Prepare a new Galaxy history
Any analysis should get its own Galaxy history. So let's start by creating a new one:

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

## Get sequencing data

> <comment-title>Importing your own data</comment-title>
> If you are going to use your own sequencing data, there are several possibilities to upload the data depending on how many datasets you have and what their origin is:
>
> - You can import data
>
>   - from your local file system,
>   - from a given URL or
>   - from a shared data library on the Galaxy server you are working on
>
>   In all of these cases you will also have to organize the imported data into a dataset collection like explained in detail for the suggested example data.
>
>   > <details-title>Data logistics</details-title>
>   >
>   > A detailed explanation of all of the above-mentioned options for getting your data into Galaxy and organizing it in your history is beyond the scope of this tutorial.
>   > If you are struggling with getting your own data set up like shown for the example data in this section, please:
>   > - Option 1: Browse some of the material on [Using Galaxy and Managing your Data]({% link topics/galaxy-interface %})
>   > - Option 2: Consult the FAQs on [uploading data]({% link faqs/galaxy/index.md %}#data%20upload) and on [collections]({% link faqs/galaxy/index.md %}#collections)
>   > - Option 3: Watch some of the related brief videos from the [{% icon video %} Galactic introductions](https://www.youtube.com/playlist?list=PLNFLKDpdM3B9UaxWEXgziHXO3k-003FzE) playlist.
>   >
>   {: .details}
>
{: .comment}

## Hands-on Sections
In the following part, we'll download our data which we want to analyze or upload your own virus genomes. Since we first want to make an alignment before we determine the primers, we need sequenced genomes in fasta format. Our sample data is a fasta file with Polio 1 virus genomes.


> <hands-on-title> Data Upload Part 1 </hands-on-title>
>
> - **Option 1:** Zenodo - Upload Polio 1 virus genomes
>
>   1. Import the files from [Zenodo]({{ page.zenodo_link }}) 
>
>      {% snippet faqs/galaxy/datasets_import_via_link.md %}
>
>       The URLs for our example data are these:
>
>       ``
>       https://zenodo.org/
>       ``
>
>   2. Rename the datasets
>   3. Check that the datatype is fasta
>
>      {% snippet faqs/galaxy/datasets_change_datatype.md datatype="datatypes" %}
>
> - **Option 2:** Import your own data
>   
>   1. On the left side of [Galaxy](usegalaxy.eu), click on {% icon galaxy-upload %} Upload Data
>   2. Choose local files search or drop your files
>   3. Search your viral genomes in your local file directory
>   4. Press **Start** and close the window at 100%
>   5. Wait for data upload on the right side (until its green)
>   6. Check the datatype like above and if necessary rename it
>   7. Done.
>
{: .hands_on}

# Multiple alignment of nucleic sequences with **MAFFT**

Multiple sequence alignment (MSA) plays an important role in evolutionary analyses of biological sequences. In this part of the tutorial, we want to align the genome datasets to get knowledge about similarity and evolutionary relationship between the sequences. MAFFT is a multiple sequence alignment program, which enables the analysis of a file with several sequences with different alignment algorithms.

When multiple files are added, MAFFT will run for each of these, so it is necessary to have every sequence, which you want to have aligned, in one file. For that there is in the tool MAFFT on Galaxy a concatenate option implemented. For further information look in details below:

> <details-title> MAFFT - 2 Concatenate options </details-title>
>
>   Concatenating a FASTA file involves combining multiple FASTA-formatted sequences into a single file. This can be useful when you have sequences from different sources or experiments that you want to analyze together. MAFFT offers 2 different options.
>
> **Option 1:**
>   
>   - Upload several fasta files in different dataset upload sections and cross concatenate following the rule, first file of 1. section with first file of 2. section ect. You can add as many dataset section as you want.
>   - If you want to make multiple alignments of many files seperately, upload them in the first dataset section and don't add a 2. datasets section.
>
> **Option 2:**
>
>   - Concatenate simply every fasta in a row, if in the same dataset section or in different section. means 1. dataset section has two files and 2. section three files resulting in one endfile with thesequence order of the files: 1, 2, 3, 4, 5.
>
{: .details}


**Standard settings:**
- Autodetection of the sequence type (nucleic or amino acid)
    - if nuc, matrix is Kimura200
    - if prot, matrix is BLOSUM62
- alignment strategy auto choose(FFT-NS-2 or L-INS-i, depending on sequence number)  = FFT-NS-2 fast, but rough, recommended for larger sequences
- Gap Extend Penalty = 0.0
- Gap Open Penalty = -1.53


> <details-title> MSA: Multiple sequence alignment with MAFFT - Methods </details-title>
>
>   MAFFT is a program which offers many ways of customization. In this comment you'll find the ready to use multiple alignment methods:
>
> - Accuracy-oriented methods:
>
>    1. L-INS-i (probably most accurate; recommended for <200 sequences; iterative refinement method incorporating local pairwise alignment information)
>
>    2. G-INS-i (suitable for sequences of similar lengths; recommended for <200 sequences; iterative refinement method incorporating global pairwise alignment information)
>
>    3. E-INS-i (suitable for sequences containing large unalignable regions; recommended for <200 sequences)
>
> - Speed-oriented methods:
>
>    1. FFT-NS-i (iterative refinement method; two cycles only):
>
>    2. FFT-NS-2 (fast; progressive method)
>
>    3. NW-NS-i (iterative refinement method without FFT approximation; two cycles only)
>
>    4. NW-NS-2 (fast; progressive method without the FFT approximation)
>
> - Costum setting:
>
>   There is a wide range of personal adjustements offered by MAFFT. Each of these falvours can be set independently on your own. For more information about the algorithms and parameters: [Visit the official MAFFT-website](https://mafft.cbrc.jp/alignment/software/algorithms/algorithms.html)
>
{: .details}

## Settings MAFFT
Now its your turn. Insert the parameter like in the following section.

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [MAFFT](toolshed.g2.bx.psu.edu/repos/rnateam/mafft/rbc_mafft/7.508+galaxy1) %} with the following parameters:
>    - {% icon param-file %} *"Sequences to align"*:Congratulations! `Polio1_genomes.fasta` (Input Polio 1 dataset)
>    - *"Type of sequences"*: `auto-detect` or `Nucleic acids`
>    - *"Configure gap costs"*: `Use default values`
>    - *"MAFFT flavour"*: `FFT-NS-2 (fast, progressive method)`
>    - *"Output format"*: `FASTA`
>
>    > <comment-title> Different flavor, different time and accuracy </comment-title>
>    >
>    > The alignment will be quite fast with the FFT-NS-2 flavor. You can try it out with G-INS-I for example, then you'll see the time and accuracy difference of the algorithms, which MAFFT can offer.
>    {: .comment}
>
{: .hands_on}

## Output
The aligned polio genome is ready for further use. Before we continue with the primer design, we'll have a look at our output. First, giving the output a proper name will help handling numberous data in future. Secondly, sometimes it is helpfull to visualize the whole alignment or specific region of interests. If you want a visualization of the sequences, Galaxy has an interactive build-in function, which we are going to discover in the next Hands-on-box.

> <hands-on-title>Visualize the multiple-sequence alignment</hands-on-title>
>
> 1. Visualize the multiple-sequence alignment
>    1. Click on the MAFFT output to expand this dataset
>    2. Click on {% icon galaxy-barchart %} **Visualize**
>    3. Maximize the browser window (the visualization we are about to launch will not rescale properly if you do this later!)
>    3. Select **Multiple Sequence Alignment** as the visualization
>    4. Wait for the alignment to finish loading
>    5. You can now scroll through the alignment by dragging the scroll-bar, or move through it in windows by clicking next to it on the same line. You can also go to a specific position in the alignment directly via **Extras** -> **Jump to a column**.
>
>       You can manually check some regions of the alignment to see whether they fit the next figure.
>
{: .hands_on}

![Picture of the build-in visualization of Galaxy of an aligned Polio 1 genome.](../../images/mafft_varvamp_training/aligned_Polio1_sequence128-142.png "Visualization of the aligned Polio 1 genome through Galaxy build-in view. Options for customization or better analysis on top. Shown are sequence 128-142 with few differences.")

With this alignment we prepared our input Poliovirus 1 genomes for VarVAMP and are ready to design our primers. But before we get to the primer design section with VarVAMP, we have simple questions for you.

> <question-title></question-title>
>
> 1. What does MAFFT?
> 2. What kind of alignment method is recommended for our kind of data and why?
>
> > <solution-title></solution-title>
> >
> > 1. Creates an alignment file, which shows parts of similar sequences.
> > 2. The speed-oriented methods, because there are too many sequences (>200) and it would take too long.
> >
> {: .solution}
>
{: .question}



# Primer design with **VarVAMP**

Properly designed primers contribute to the specificity, efficiency, and accuracy of techniques like PCR and DNA sequencing, ultimately influencing the reliability and validity of biological research outcomes. Variable VirusAMPlicons (varVAMP) is a tool to design primers for highly diverse viruses. The input is an alignment of your viral (full-genome) sequences.

> <details-title> Functionality of VarVAMP </details-title>
>
> For a lot of virus genera it is difficult to design pan-specific primers. varVAMP solves this by introducing ambiguous characters into primers and minimizes mismatches at the 3' end. Primers might not work for some sequences of your input alignment but should recognize the large majority.
>
>   VarVAMP comes in three different flavors:
>
>   1. **SINGLE:** varVAMP searches for the very best primers and reports back non-overlapping amplicons which can be used for PCR-based screening approaches.
>   2. **TILED:** varVAMP uses a graph based approach to design overlapping amplicons that tile the entire viral genome. This designs amplicons that are suitable for Oxford Nanopore or Illumina based full-genome sequencing.
>   3. **QPCR:** varVAMP searches for small amplicons with an optimized internal probe (TaqMan). It minimizes temperature differences between the primers and checks for amplicon secondary structures.
>
{: .details}

The tool VarVAMP offers a wide range of different outputs in the variuos modes. For example it is possible to get the location of the designed primers or the amplicon graphical or in bed file format, gain information about the region or other potential primers. You will find further information in the next detail box. The VarVAMP Analysis log file gives information about the settings and procedures of the tool and will always be distributed.

> <details-title> Output of VarVAMP </details-title>
>
> VarVAMP has a lot of different outputs, which you can select. Here you can find a short summery:
>
> **Primer scheme outputs:**
>   - *Sequences of designed oligos:*
>       - Sequences of all designed oligos 
>   - *Primer binding sites:*  
>       - Primer binding sites in BED format; includes primer penalties (lower is better) as the score column
>   - *Amplicon locations:*
>       -  Amplicon locations in BED format; includes amplicon penalties (lower is better) in the score column 
>   - *Primer details:*
>       -  Primer details in tabular format
>   - *Primer to amplicon assignment:* ~ *only in SINGLE and TILED*
>       -  Primer-to-amplicon assignment in tabular format; lists primers belonging to the same amplicon on one line for simpler automated parsing
>   - *Unresolved primer dimers:* ~ *only in TILED*
>       - If any primers in the tiling scheme are predicted to form primer dimers, details about these will be found in this tabular output 
>   - *qPCR amplicon details:* ~ *only in QPCR*
>       - qPCR amplicon details in tabular format 
>
> **Consensus sequence and alignment-related outputs:**
>   - *Ambiguous consensus sequence:*
>       - The consensus sequence containing ambiguous nucleotides; this sequence is what positional information in primer scheme outputs is referring to!
>   - *Majority consensus sequence (no ambiguity codes):*
>       - Consensus sequence without ambiguous nucleotide codes, but with the most prevalent nucleotide at each position instead. 
>   - *Alignment cleaned:*
>       -  The preprocessed alignment used to build consensus sequences 
>
> **Graphical outputs:**
>   - *Amplicon design overview plot:*
>       - Amplicon design overview
>   - *Per-base mismatches barplots:*
>       -  Per-primer barplot of mismatches to input sequences
> 
> **Other/intermediate outputs:**
>   - *All candidate primer regions:*
>       -  List of all candidate regions of the consensus sequence that were evaluated for primers in BED format 
>   - *All primer sites:* ~ *only in SINGLE and TILED*
>       -  Binding sites of ALL high-scoring primers that were considered in BED format; includes primer penalties (lower is better) as the score column
>   - *All candidate qPCR probe regions:* ~ *only in QPCR*
>       -  List of all candidate regions of the consensus sequence that were evaluated for qPCR probes in BED format 
>
{: .details}

## Settings for the first primer design
In our case we want to create primers for quantitative Polymerase Chain Reaction or also known as real-time PCR, that means we have to choose the third flavor *QPCR*.

> <hands-on-title> Tool settings for QPCR-Primers </hands-on-title>
>
> 1. {% tool [varVAMP](toolshed.g2.bx.psu.edu/repos/iuc/varvamp/varvamp/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Multiple alignment of viral sequences"*: `outputAlignment` (output of **MAFFT** {% icon tool %})
>    - *"What kind of primers would you like to design? (varvamp mode)"*: `qPCR primers (qpcr)`
>        - *"How to set the main parameters, threshold for consensus nucleotides and max ambiguous nts per primer?"*: `Specify values for both`
>        - *"Threshold for consensus nucleotides*": `0.93`
>        - *"Maximum number of ambiguous nucleotides per primer to be tolerated (default: 2)"*: `2`
>        - *"Maximum number of ambiguous nucleotides per qPCR probe to be tolerated"*: `1`
>
{: .hands_on}

### Output
Now we got our first VarVAMP outputs and an idea, how the tool is working. Check the different kind of outputs and get familiar with the results.

> <comment-title> Output control </comment-title>
>
> Control your output files with the example files of the [VarVAMP-qPCR-output github page for Polio 1 virus](https://github.com/jonas-fuchs/ViralPrimerSchemes/tree/main/varvamp_qpcr/polio1). There you can check, if you have created the same primers. Attention, the files are named differently. You can find the primers in the file "primers.tsv".
{: .comment}

For practicing further options, we'll now get Polio 1-3 genome data and create virus genome primers for another use case with the *TILED* flavor. These primers are suitable for Oxford Nanopore or Illumina based full-genome sequencing.

But first of all, we have some questions for you prepared:

> <question-title></question-title>
>
> 1. What makes VarVAMP so useful?
> 2. When you checked the primers on the website, differ these primers with your designed ones?
> 3. As mentioned earlier, VarVAMP can produce different kind of outputs. What is the position of the first amplicon?
>
> > <solution-title></solution-title>
> >
> > 1. VarVAMP can produces highly personalized primers for a large number of viruses.
> > 2. No, there are likely the same. Only the position differs slightly.
> > 3. You can find the answer in the amplicons.bed file. The first amplicon starts at 466 and ends at 608.
> {: .solution}
>
{: .question}


## Settings for the second primer design
In order to be able to compare the results and prove the reproducibilty, we'll can find the control primers on the [Viral Primer Schemes github page of Jonas Fuchs](https://github.com/jonas-fuchs/ViralPrimerSchemes/tree/main/varvamp_tiled/Polio) as before. As mentioned, we'll prepare primers for Next Generation Sequencing instead of qPCR with the aligned genome data of Polio 1-3. 

### Get the aligned genome sequences of Polio virus 1-3
For time reasons we skip the multiple alignment part with MAFFT and provide you the aligned fasta file through Zenodo.

> <hands-on-title> Data Upload Part 2 </hands-on-title>
>
> - **Zenodo-Upload** - Upload Polio 1-3 aligned virus genomes
>
>   1. Make a new history and rename it
>   2. Import the files from [Zenodo]({{ page.zenodo_link }}) 
>
>      {% snippet faqs/galaxy/datasets_import_via_link.md %}
>
>      ``
>      https://zenodo.org/
>      ``
>   
>   3. Rename the datasets
>   4. Check that the datatype is fasta
>
{: .hands_on}

In the next go-through with VarVAMP, we will get to know the *TILED* flavor. As we have no more probe to generate there a certain parameter, which are different from the *QPCR* flavor. For example is it now possible to adjust the optimal or maximum length of the amplicon and the minimal number of nucleotides overlapping. Two important settings, which you can find in every flavor of VarVAMP is n_ambig, the number of ambigious nucleotides in your primer, and the threshold of consensus nucleotides to ensure the specifity of your design.

> <hands-on-title> Tool settings for TILED-Primers </hands-on-title>
>
> 1. {% tool [varVAMP](toolshed.g2.bx.psu.edu/repos/iuc/varvamp/varvamp/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Multiple alignment of viral sequences"*: `polio1-3_fftns.fasta`
>    - *"What kind of primers would you like to design? (varvamp mode)"*: `Tiled primer scheme for whole-genome sequencing (tiled)`
>        - *"How to set the main parameters, threshold for consensus nucleotides and max ambiguous nts per primer?"*: `Specify values for both`
>        - *"Threshold for consensus nucleotides"*: `0.91`
>        - *"Maximum number of ambiguous nucleotides per primer to be tolerated (default: 2)"*: `4`
>        - *"Optimal length of the amplicons"*: `1000`
>        - *"Maximal length of the amplicons"*: `1400`
>        - *"Minimal required overlap between tiled amplicons*: `100`
>
{: .hands_on}

### Output
As you can see in the output on the right side, you'll have succesfully created primers for further amplification of your viral sequences. Compare your results with the "primers.tsv" on the [Viral Schemes Website](https://github.com/jonas-fuchs/ViralPrimerSchemes/tree/main/varvamp_tiled/Polio).

Again, we have some questions for you prepared:

> <question-title></question-title>
>
> 1. What is the longest amplicon of the flavors TILED and qPCR respectively?
> 2. What's the difference of the functionality 2 flavors qPCR and TILED?
> 3. If you want to have a more accurate product, which option do you have to manipulate?
>
> > <solution-title></solution-title>
> >
> > 1. In TILED over 1000 nucleotides long and in qPCR around 180 length.
> > 2. The qpcr flavor reports back small amplicons with an optimized internal probe. The TILED flavor overlapping amplicons for Oxford Nanopore or Whole Genome Sequencing.
> > 3. Increase of length of amplicon, minimal required overlap and threshold or decrease of maximum number of ambiguous nucleotides per primer.
> >
> {: .solution}
>
{: .question}

## Settings for the third primer design with off-target analysis through BLAST database
In out last step, imagine we have a sample to examine, which was taken from virus infected human tissue. We want to be sure, that we are not amplifing any human genes with our viral gene material. How do we get rid of the human parts of our sample?




With VarVAMP, it is possible to insert a BLAST database as an off-target reference. We can use the NCBI tool makeblastdb to create a BLAST database of the human genome and use it as a reference. Now we can compare it with the sample and avoid designing primers for human genetic material. An application example would be primer design for NGS to identify related viral genomes in a human sample.

The following steps are:

1. Create a human genome database with ncbi makeblastdb.

2. Use the builded BLAST database with VarVAMP to check amplicon primer candidates against.

3. Get my identified viral primers for further precedures like Next Generation Sequencing.

> <hands-on-title>BLAST human genome database and primer design of all Polio viruses (1-3)</hands-on-title>
>
> 1. {% tool [NCBI BLAST+ makeblastdb](toolshed.g2.bx.psu.edu/repos/devteam/ncbi_blast_plus/ncbi_makeblastdb/2.14.1+galaxy1) %} with the following parameters:
>   - *"Molecule type of input"*: `nucleotide`
>       - {% icon param-repeat %} **Insert Select Input**
>           - *"Input is a"*: `Genome on Server`
>           - *"Installed genome"*: `Human Dec. 2013 (GRCh38/hg38) (hg38)`
>   - *"Title for BLAST database"*: "Human Genome"
>   - ignore the containing masking data file upload panel
>
> 2. {% tool [varVAMP](toolshed.g2.bx.psu.edu/repos/iuc/varvamp/varvamp/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Multiple alignment of viral sequences"*: new uploaded aligned Polio 1-3 genomes 
>    - *"What kind of primers would you like to design? (varvamp mode)"*: `Tiled primer scheme for whole-genome sequencing (tiled)`
>        - *"How to set the main parameters, threshold for consensus nucleotides and max ambiguous nts per primer?"*: `Specify values of both`
>        - *"Avoid amplicons with off-target primer products?"*: `Yes`
>           - *"BLAST database"*: the output of **NCBI makeblastdb** `Human Genome`
>           - *"Customize BLAST Settings?"*: `No, use VarVAMP default settings`
>
>    > <comment-title> Outputs reminder </comment-title>
>    >
>    > Look up the different outputs you can get from this tool. Maybe some of them are more useful than other for your further analysis.
>    {: .comment}
>
{: .hands_on}

### Output
Now we have generated our primers for the different polio viruses and we can be sure that there are not related to the human genome which we used as a reference against.

Last but not least, we have some questions for you prepared:

> <question-title></question-title>
> 
> 1. Whats the meaning of the n-ambig parameter?
> 2. What was the goal of the analysis with the additional BLAST database?
>
> > <solution-title></solution-title>
> >
> > 1. N_ambig describes the potential variable nucleotides in one primer. Means the larger the more unspecific.
> > 2. To eliminate human genome from the sample.
> >
> {: .solution}
>
{: .question}


**Congratulations! You've finished the Galaxy training!**

# Conclusion

Creating primers for further gene analysis is essential. VarVAMP delivers a possibility to design highly divers and personally specified primers and even the option to eliminate off-targets thanks to a BLAST database. In combination with MAFFT, a strongly adjustable multiple alignment tool, it is possible to search for similar genome sequences in a sample batch and if there have viral origin, be able to do preparatory work for the amplification technique of interest. This Galaxy workflow is therefore extremely useful for applications such as the identification of related virus genomes.
