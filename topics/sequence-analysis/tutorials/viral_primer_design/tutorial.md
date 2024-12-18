---
layout: tutorial_hands_on

title: Primer and primer scheme design for pan-specific detection and sequencing of viral pathogens across genotypes
level: Introductory
questions:
- What are pan-specific primers and primer schemes and why are they important?
- How do you capture viral species diversity in the form of a multiple sequence alignment?
- How do you design primers that will be mostly unaffected by differences between viral genotypes?
- How do you avoid generating primers with off-target binding sites?
    
objectives:
- Reproduce published qPCR primers and primer schemes for polio virus using MAFFT and varVAMP
- Gain the knowledge and confidence to create your own primers and primer schemes

time_estimation: 1H
key_points:
- Robust pan-specific primers and primer schemes are important to avoid false-negatives in diagnostic settings and poorly covered samples in sequencing projects
- A multiple sequence alignment that captures well the underlying sequence diversity of the viral pathogen of interest is a prerequisite for designing good pan-specific primers/primer schemes
- varVAMP is an excellent solution for automating the design of primers and whole primer schemes from multiple sequence alignments of representative viral genotypes
- By passing a BLAST database of off-target sequences to varVAMP you can reduce the risk of designing primers binding to these sequences
contributions:
  authorship:
  - VerenaMoo
  - elischberg
  - wm75
  funding:
  - by-covid
tags:
- virology
---

Modern molecular, DNA and RNA-based methods have seen ever increasing use, over the last decades, in the detection and analysis of viral pathogens. Most of these methods rely on PCR for amplification of viral DNA/RNA and are, thus, dependent on primers that recognize viral targets reliably and selectively. Designing such primers can be challenging if the diversity of viral genotypes that need to be recognized by the primers is high.

Quantitative real-time PCR (qPCR) is a very well established tool for detection of viral pathogens and for estimating viral load in samples. In its most widely used form in molecular diagnosis, qPCR requires two primers for amplification of a stretch of viral genetic material and an additional oligonucleotide probe that recognizes the amplified sequence and is itself used for fluorescence-based detection. Hence, in this case, three oligonucleotide sequences need to be designed that must recognize all viral genotypes of interest.

More recently, starting with the Zika virus epidemic from 2015 to 2016 and boosted by the 2020-2023 SARS-CoV-2 pandemic, tiled-amplicon sequencing has emerged as a powerful method for reconstructing full viral genomes directly from samples obtained from patients ({% cite Quick2017 %}). This method relies on multiplex PCRs to obtain amplification products (amplicons) that together cover (nearly) the complete genome of the viral pathogen. Overlap between amplicons (tiling) is required to achieve gap-free genome reconstruction and overlaping amplicons are generated in separate multiplex PCR reactions (pools) to avoid interaction of products during PCR. In this case each single amplicon is generated from two primers that, ideally, all need to be able to recognize all relevant viral genotypes and should, as far as possible not interact with other primers present in the same amplification pool. To illustrate the complexity involved, consider the example of SARS-CoV-2: [version 5.3.2](https://github.com/artic-network/primer-schemes/tree/master/nCoV-2019/V5.3.2) of the [ARTIC network](https://artic.network/)'s SARS-CoV-2 primer scheme defines 192 primers that generate 48 amplicons in each of two amplification pools and all these primers should bind efficiently to the genome sequences of all currently (first half of 2024) circulating omicron lineages (see the [v5.3.2 primer scheme announcement](https://community.artic.network/t/sars-cov-2-version-5-3-2-scheme-release/462) for the full details).

While SARS-CoV-2 is an extremely well-studied example, many other viral pathogens display a far greater sequence diversity than that of existing SARS-CoV-2 lineages making it even harder to come up with pan-specific primer sets for reliable amplification of arbitrary samples of unknown genotype. The three serotypes of poliovirus (PV-1, PV-2 and PV-3), for example, share only ~70% pairwise sequence identity with one another (compared to still ~ 99% for current SARS-CoV-2 lineages).

In this tutorial we investigate a robust bioinformatics approach that lets you design pan-specific PCR primers or entire primer schemes for viral pathogens with high sequence diversity. The design process starts from known genome sequences of viral isolates, which are supposed to represent the existing sequence diversity of the viral pathogen across its genotypes. From these sequences, we build a multiple-sequence alignment, which then serves as input to the primer design tool **varVAMP**. This tool will try to identify possible primer sites that are conserved enough to work across genotypes while considering user-specified constraints like amplicon sizes for tiled-amplicon sequencing or desired qPCR probe characteristics.

> <agenda-title></agenda-title>
>
> In this tutorial, we will cover:
>
> 1. TOC
> {:toc}
>
{: .agenda}

# Data and Galaxy preparation

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
>    {% snippet faqs/galaxy/histories_rename.md name="viral-primer-scheme-design tutorial" %}
>
{: .hands_on}

## Get viral reference sequences

> <hands-on-title>Get the Polio 1 sequence alignment</hands-on-title>
>
>    1. Get the Polio 1 sequence alignment from
>
>       ```
>       https://raw.githubusercontent.com/jonas-fuchs/ViralPrimerSchemes/79db0cc128079d770f2282b68a6e28142fd77473/input_alignments/polio1.aln
>       ```
>       and upload it to your history via the link above and make sure the dataset format is set to `fasta`.
>
>       {% snippet faqs/galaxy/datasets_import_via_link.md format="fasta" %}
>    2. Rename the dataset
>
>       {% snippet faqs/galaxy/datasets_rename.md name="Polio 1 alignment" %}
>
{: .hands_on}

## Transform aligned sequences into unaligned fasta file format
To effectively utilize **MAFFT**({% cite Katoh2013 %}), a powerful tool for multiple sequence alignment, it's crucial to provide an unaligned fasta sequence file as input. This raw format allows MAFFT to flexibly align sequences based on their similarity, adjusting gaps and mismatches to optimize alignment quality. Furthermore is the transformation of the aligned file a helpful exercise to deepen the knowledge about the variety and diversity of different tools existing on the Galaxy website.

> <hands-on-title>Degap the Polio1-genomes</hands-on-title>
>
>    1. {% tool [degapseq](toolshed.g2.bx.psu.edu/repos/devteam/emboss_5/EMBOSS: degapseq20/5.0.0) %} with the following parameter:
>       - {% icon param-file %} *"On query"*: `Polio 1 alignment` (Input Polio 1 dataset)
>       - *"Output sequence file format"*: `FASTA (m)`
>
>    2. Rename the dataset
>
>       {% snippet faqs/galaxy/datasets_rename.md name="Polio 1 unaligned" %}
>
{: .hands_on}

# Designing a pan-specific primer/probe combination for qPCR

## Multiple alignment of reference sequences

*Multiple sequence alignment (MSA)* plays an important role in evolutionary analyses of biological sequences. In this part of the tutorial, we want to align the genome datasets to get knowledge about similarity and evolutionary relationship between the sequences. **MAFFT** is a multiple sequence alignment program, which enables the analysis of a file with several sequences with different alignment algorithms.

When multiple files are added, MAFFT will run for each of these, so it is necessary to have every sequence, which you want to have aligned, in one file. Therefore there is a concatenate option in MAFFT on Galaxy implemented. For further information look in details below:

> <details-title> MAFFT - 2 Concatenate options </details-title>
>
>   Concatenating a FASTA file involves combining multiple FASTA-formatted sequences into a single file. This can be useful when you have sequences from different sources or experiments that you want to analyze together. MAFFT offers 2 different options.
>
> **Option 1:**
>
>   - Upload several fasta files in different dataset upload sections and cross concatenate following the rule, first file of 1. section with first file of 2. section ect. You can add as many dataset sections as you want.
>   - If you want to make multiple alignments of many files seperately, upload them in the first dataset section and don't add a 2. datasets section.
>
> **Option 2:**
>
>   - Concatenate simply every fasta in a row, if in the same dataset section or in different section. means 1. dataset section has two files and 2. section three files resulting in one endfile with the sequence order of the files: 1, 2, 3, 4, 5.
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
>   There is a wide range of personal adjustements offered by MAFFT. Each of these flavours can be set independently on your own. For more information about the algorithms and parameters: [Visit the official MAFFT-website](https://mafft.cbrc.jp/alignment/software/algorithms/algorithms.html)
>
{: .details}

> <hands-on-title>Generate multiple sequence alignment</hands-on-title>
>
> 1. {% tool [MAFFT](toolshed.g2.bx.psu.edu/repos/rnateam/mafft/rbc_mafft/7.508+galaxy1) %} with the following parameters:
>    - {% icon param-file %} *"Sequences to align"*: `Polio 1 unaligned` (Input degapped Polio 1 dataset from history)
>    - *"Type of sequences"*: `auto-detect` or `Nucleic acids`
>    - *"MAFFT flavour"*: `FFT-NS-2 (fast, progressive method)`
>    - *"Output format"*: `FASTA`
>
>    > <comment-title> Different flavor, different time and accuracy </comment-title>
>    >
>    > The alignment will be quite fast with the FFT-NS-2 flavor. You can try it out with G-INS-I for example, then you'll see the time and accuracy difference of the algorithms, which MAFFT can offer. It will take a while, so please don't wait for the result before you continue with the training. When it finished, check the first aligned sequence file with the second to evaluate the differences of the alignment methods.
>    {: .comment}
>
> 2. Rename the dataset
>      
>    {% snippet faqs/galaxy/datasets_rename.md name="Polio 1 MSA" %}
>
{: .hands_on}

The aligned polio genome is ready for further use. Before we continue with the primer design, we'll have a look at our output. First, giving the output a proper name will help handling numberous data in future. Secondly, sometimes it is helpfull to visualize the whole alignment or specific region of interests. If you want a visualization of the MSA, Galaxy has an interactive build-in function, which we are going to discover in the next Hands-on-box.

> <hands-on-title>Visualize the multiple-sequence alignment</hands-on-title>
>
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
> 1. How many sequences were aligned and how long are they?
> 2. What kind of alignment method is recommended for our kind of data and why?
> 3. What does the height of the bars in the top row above the position of the bases indicate?
>
> > <solution-title></solution-title>
> >
> > 1. In total 241 sequences were aligned with up to 7498 bases.
> > 2. The speed-oriented methods, because there are too many sequences (>200) and it would take too long.
> > 3. The height of the bars indicates the degree of sigitmilarity of the bases at this position.
> >
> {: .solution}
>
{: .question}

## One-step primer and probe design without consideration of off-target sites

Properly designed primers contribute to the specificity, efficiency, and accuracy of techniques like PCR and DNA sequencing, ultimately influencing the reliability and validity of biological research outcomes. *Variable VirusAMPlicons* (*varVAMP*) is a tool to design primers for highly diverse viruses. The input is an alignment of your viral (full-genome) sequences.

> <details-title>Functionality of VarVAMP</details-title>
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

The tool VarVAMP offers a wide range of different outputs in the various modes. For example is it possible to get the location of the designed primers, the amplicon or in bed file format or in a graphical pdf format, to gain information about the region or other potential primers. You will find further information in the next detail box. The VarVAMP Analysis log file gives information about the settings and procedures of the tool and will always be distributed.

> <details-title>Output of VarVAMP</details-title>
>
> VarVAMP has many different outputs, which you can select. Here you can find a short summery:
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

> <hands-on-title>Generate qPCR primer/probe set</hands-on-title>
>
> 1. {% tool [varVAMP](toolshed.g2.bx.psu.edu/repos/iuc/varvamp/varvamp/1.1.2+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Multiple alignment of viral sequences"*: `Polio 1 MSA` (output of **MAFFT** {% icon tool %})
>    - *"What kind of primers would you like to design? (varvamp mode)"*: `qPCR primers (qpcr)`
>        - *"How to set the main parameters, threshold for consensus nucleotides and max ambiguous nts per primer?"*: `Specify values for both`
>        - *"Threshold for consensus nucleotides"*: `0.93`
>        - *"Maximum number of ambiguous nucleotides per primer to be tolerated (default: 2)"*: `2`
>        - *"Maximum number of ambiguous nucleotides per qPCR probe to be tolerated"*: `1`
>        - *"Top n qPCR amplicons to test"*: `50`
>        - *"Minimum free energy (kcal/mol/K) cutoff*: `-3`
>
>       ><comment-title>Right time for dataset</comment-title>
>       >
>       >In the next step, we'll create a dataset collection, because the numberous output data will soon make the history look unorganized and it will make it easier for you to distinguish between the results. Wait for the outputs of varVAMP to get green and then go on to the next step and create a dataset.
>       {: .comment}
>
> 2. Creating a dataset collection 
>
>    {% snippet  faqs/galaxy/collections_build_list.md name="varVAMP Polio1 qpcr threshold 0.93" %}
{: .hands_on}

Now we got our first VarVAMP outputs and an idea, how the tool is working. Wee have put them together in a dataset to keep an organized overview. Check the different kind of outputs and get familiar with the results.

> <comment-title>Output control</comment-title>
>
> Control your output files with the example files of the [VarVAMP-qPCR-output github page for Polio 1 virus](https://github.com/jonas-fuchs/ViralPrimerSchemes/tree/main/varvamp_qpcr/polio1). There you can check, if you created the same primers. You can find the primer locations in the bed file "primers.bed".
{: .comment}

In addition to be certain, that these primers are coding only for Polio 1 viral genomes instead of human or other viral genome sequences, it is possible to use a BLAST database as reference for detection of off-target binding sites. We'll get to this feature in the next section.

But first of all, we have some questions for you prepared:

> <question-title></question-title>
>
> 1. What makes VarVAMP so useful?
> 2. When you checked the primers on the website, differ these primers with your designed ones in regard of the position?
> 3. As mentioned earlier, VarVAMP can produce different kind of outputs. What is the position of the first amplicon?
> 4. How is it possible to increase the reproducibility and decrease the computing time of further analysis of VarVAMP?
>
> > <solution-title></solution-title>
> >
> > 1. VarVAMP can produces highly personalized pan-specific primers for a large number of viruses.
> > 2. No, there are likely the same. This means the result can be reproduced.
> > 3. You can find the answer in the *"Amplicon locations"* file. The first amplicon starts at 1742 and ends at 1835.
> > 4. The solution lies in the per default contributed log file. It contains the parameter configuration of your latest VarVAMP run. If you save and use the values of the threshold and n_ambig for further runs, VarVAMP will not start it's automatic calculation of these and thus results in lower computing time and higher reproducibility.
> {: .solution}
>
{: .question}

## Advanced approach considering off-target sites for the output,
In our next step, imagine we have a sample to examine, which was taken from virus infected human tissue. We want to be sure, that we are not amplifing any other related enterovirus genome sequences with our polio gene material in our analysis. How do we get to be sure, we specificly build primers for our viral genome of interest?

With varVAMP, it is possible to insert a BLAST database as an off-target reference. We can use the *NCBI BLAST makeblastdb* ({% cite Cock2015 %}) to create a BLAST database of other whole genomes of entereroviruses and use it as a reference. The found primers will be compared with the reference and each hit is given a high penalty. In order to choose the best fitting primer scheme, varVAMP sorts the possible primers by their penalty score and hence avoids designing primers for possible similar genome regions of other organisms. An application example afterwards would be real-time detection of polio 1 viral genomes in a human sample for pandemic surveillance.

The following steps are:

1. Upload the enterovirus genome data into Galaxy.

2. Create a enterovirus genome database with ncbi makeblastdb.

3. Use the builded BLAST database with VarVAMP to check amplicon primer candidates against.

> <hands-on-title>Get the whole genome sequences of enterovirus</hands-on-title>
> 1. Get the genome sequence fasta files from
>
>    ```
>    
>    ```
>    and upload it to Galaxy as a dataset of type `fasta`.
>
>    {% snippet faqs/galaxy/datasets_import_via_link.md format="fasta" %}
>
> 2. Rename the dataset (optional)
>
>    {% snippet faqs/galaxy/datasets_rename.md name="Enterovirus genome sequences" %}
>
{: .hands_on}

Now that we got our data, we can start the analysis by providing the data to NCBI makeblastdb to create a database. This will give us the possibility to detect off-target hits with varVAMP.

> <hands-on-title>BLAST enterovirus genome database and primer design of Polio virus</hands-on-title>
>
> 1. {% tool [NCBI BLAST+ makeblastdb](toolshed.g2.bx.psu.edu/repos/devteam/ncbi_blast_plus/ncbi_makeblastdb/2.14.1+galaxy2) %} with the following parameters:
>    - *"Molecule type of input"*: `nucleotide`
>        - {% icon param-repeat %} **Select Input**
>            - *"Input is a"*: `Dataset in history`
>            - *"FASTA input"*: `Enterovirus genome sequences`
>    - *"Title for BLAST database"*: `Enterovirus genome db`
>
> 2. Rename the dataset
>      
>    {% snippet faqs/galaxy/datasets_rename.md name="Enterovirus genome db" %}
> 3. {% tool [varVAMP](toolshed.g2.bx.psu.edu/repos/iuc/varvamp/varvamp/1.1.2+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Multiple alignment of viral sequences"*: `Polio 1 MSA`
>    - *"What kind of primers would you like to design? (varvamp mode)"*: `qPCR primers (qpcr)`
>        - *"How to set the main parameters, threshold for consensus nucleotides and max ambiguous nts per primer?"*: `Specify values for both`
>           - *"Threshold for consensus nucleotides"*: `0.93`
>           - *"Maximum number of ambiguous nucleotides per primer to be tolerated (default: 2)"*: `2`
>           - *"Maximum number of ambiguous nucleotides per qPCR probe to be tolerated"*: `1`
>        - *"Top n qPCR amplicons to test"*: `50`
>        - *"Minimum free energy (kcal/mol/K) cutoff*: `-3`
>        - *"Avoid amplicons with off-target primer products?"*: `Yes`
>           - *"BLAST database"*: the output of **NCBI makeblastdb** `Enterovirus genome db`
>           - *"Customize BLAST Settings?"*: `No, use VarVAMP default settings`
>
> 4. Creating a dataset collection
>
>    {% snippet  faqs/galaxy/collections_build_list.md name="varVAMP Polio1 qpcr threshold 0.93 + BLAST" %}
{: .hands_on}

We produced 3 possible primer schemes with our current settings for further qPCR. How do we check, if these are appropriate primer designs which exclude maybe off-targets?
You know already, that there is a certain bed file output of the qpcr setting of varVAMP, which is called *"Amplicon locations"*. As the name says, it gives information about the start and the end position of the amplicons and, very important, the penalty score. Look it up and compare it to the amplicon location bed file of the first varVAMP run.

Please try to answer the following questions.

> <question-title></question-title>
> 
> 1. Whats the difference between the scores of the 2 bed files?
> 2. What does the difference mean?
> 3. Why did varVAMP choose these primers anyway?
> 4. What can be modified in our settings, to get more possible primers?
>
> > <solution-title></solution-title>
> >
> > 1. The second amplicon locations file has the same number of penalty but with 50 points in addition.
> > 2. Because of the enterovirus BLAST db reference, the same primer schemes of the first varVAMP run were found as off-targets and got additional penalty.
> > 3. There were only these 3. VarVAMP didn't have much more choice.
> > 4. Our threshold for consensus sequences with 0.93 is quite high. With a lower threshold, we will get more potential primer schemes.
> {: .solution}
>
{: .question}

Now let's try it out with a lower threshold, to get a primer scheme which is not penalized by the detection as off-target through the BLAST database. With a lower threshold value, the specificy minimizes as well, but values above 0.7 are acceptable and it depends hardly on the use case. The default value is 0.8, so let's get going with this value.

> <hands-on-title>Primer design of Polio 1 virus with BLAST db and lower threshold</hands-on-title>
>
> 1. {% tool [varVAMP](toolshed.g2.bx.psu.edu/repos/iuc/varvamp/varvamp/1.1.2+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Multiple alignment of viral sequences"*: `Polio 1 MSA`
>    - *"What kind of primers would you like to design? (varvamp mode)"*: `qPCR primers (qpcr)`
>        - *"How to set the main parameters, threshold for consensus nucleotides and max ambiguous nts per primer?"*: `Specify values for both`
>           - *"Threshold for consensus nucleotides"*: `0.8`
>           - *"Maximum number of ambiguous nucleotides per primer to be tolerated (default: 2)"*: `2`
>           - *"Maximum number of ambiguous nucleotides per qPCR probe to be tolerated"*: `1`
>        - *"Top n qPCR amplicons to test"*: `50`
>        - *"Minimum free energy (kcal/mol/K) cutoff*: `-3`
>        - *"Avoid amplicons with off-target primer products?"*: `Yes`
>           - *"BLAST database"*: the output of **NCBI makeblastdb** `Enterovirus genome db`
>           - *"Customize BLAST Settings?"*: `No, use VarVAMP default settings`
>
>       > <comment-title>Threshold control</comment-title>
>       >
>       >Try out the automatic set for values like the threshold by varVAMP. If you choose on the website for *"How to set the main parameters, threshold for consensus nucleotides and max ambiguous nts per primer?"*: `Specify max ambiguous nts, estimate suitable threshold`, the tool will choose a value on its own. You can look up the value in the "Analysis log" file after you run it.
>       {: .comment}
>
> 2. Creating a dataset collection
>
>    {% snippet  faqs/galaxy/collections_build_list.md name="varVAMP Polio1 qpcr threshold 0.8 + BLAST" %}
{: .hands_on}

The newly designed primer schemes can be checked again with the "Amplicon locations" file. We got some questions for you prepared:

> <question-title></question-title>
> 
> 1. What is the difference of the lower threshold? Did you get a useful primer scheme?
> 2. What was the goal of the analysis with the additional BLAST database?
> 3. Consider other use cases for a blast database as off-target elimination!
> 4. What is the advantage of our result?
>
> > <solution-title></solution-title>
> > 1. We got more potential primer schemes. Yes, we got 3 primer schemes, which aren't penalized as off-targets by varVAMP.
> > 2. To eliminate possible off-targets in sequences by giving them a high penalty.
> > 3. If you want to prepare primers to amplify specific viral genome sequences of samples of various origins e.g. wastewater or animal blood samples for real-time surveillance through the fluorescence-based detection.
> > 4. Now we can be certain, if we get to analyze e.g. a wastewater sample, to amplify only Polio 1 viral genome sequences with these specificly designed primers.
> {: .solution}
>
{: .question}

For practicing further options, we'll now get Polio 1-3 genome data and create primers for another use case with the *TILED* flavor. These primers are suitable for Oxford Nanopore or Illumina based full-genome sequencing.

# Designing a complete pan-specific primer scheme for tiled-amplicon sequencing

As mentioned, we'll prepare primers for Next Generation Sequencing instead of qPCR with the aligned genome data of Polio 1-3. The main goal is to reproduce the whole genome of our input sequences.

To focus on the primer scheme design we will skip the multiple sequence alignment step this time and start from the pre-aligned Polio 1-3 sequences available as part of the [ViralPrimerScheme](https://github.com/jonas-fuchs/ViralPrimerSchemes) repository.

> <hands-on-title>Get Polio 1-3 sequence alignment</hands-on-title>
>
>    1. Get the Polio 1-3 sequence alignment from
>
>       ```
>       https://raw.githubusercontent.com/jonas-fuchs/ViralPrimerSchemes/9b54b17246abdff1b39c6cdd362fff67eb2945c3/input_alignments/polio1-3.aln
>       ```
>       and upload it to your history via the link above and make sure the dataset format is set to `fasta`.
>
>       {% snippet faqs/galaxy/datasets_import_via_link.md format="fasta" %}
>    2. Rename the dataset
>
>       {% snippet faqs/galaxy/datasets_rename.md name="Polio 1-3 alignment" %}
>
{: .hands_on}

In the next go-through with VarVAMP, we will get to know the *TILED* flavor. We don't generate a probe for quantasizing our pcr-product anymore, but therefore we need to specify the size of our overlapping region of the amplicons for the tiling function. Another adjustment which can be done is the optimal or maximum length determination of the amplicon. Two important settings, which you already know and can find in every flavor of VarVAMP is n_ambig, the number of ambigious nucleotides in your primer, and the threshold of consensus nucleotides to ensure the specifity of your design.

> <hands-on-title>Primer design with the TILED-flavour for whole genome amplification</hands-on-title>
>
> 1. {% tool [varVAMP](toolshed.g2.bx.psu.edu/repos/iuc/varvamp/varvamp/1.1.2+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Multiple alignment of viral sequences"*: the `Polio 1-3 alignment` just uploaded
>    - *"What kind of primers would you like to design? (varvamp mode)"*: `Tiled primer scheme for whole-genome sequencing (tiled)`
>        - *"How to set the main parameters, threshold for consensus nucleotides and max ambiguous nts per primer?"*: `Specify max ambiguous nts, estimate suitable threshold`
>        - *"Maximum number of ambiguous nucleotides per primer to be tolerated (default: 2)"*: `2`
>
> 2. Creating a dataset collection
>
>    {% snippet  faqs/galaxy/collections_build_list.md name="varVAMP Polio1-3 tiled" %}
{: .hands_on}

As you can see in the output on the right side, you'll have succesfully created primers for further amplification of your viral sequences.
You can compare your results with the "primers.bed" on the [Viral Schemes Website](https://github.com/jonas-fuchs/ViralPrimerSchemes/tree/main/varvamp_tiled/Polio).

Again, we have some questions for you prepared:

> <question-title></question-title>
>
> 1. What is the longest amplicon of the flavors TILED and qPCR respectively?
> 2. What's the difference of the functionality 2 flavors qPCR and TILED?
> 3. When you've done the comparison of the bed files from github and your created ones, where there differences? If yes, what could be the reason?
> 4. If you want to have a more accurate product, which option do you have to manipulate?
>
> > <solution-title></solution-title>
> >
> > 1. In TILED over 1000 nucleotides long and in qPCR around 180 length.
> > 2. The qpcr flavor reports back small amplicons with an optimized internal probe. The TILED flavor overlapping amplicons for Oxford Nanopore or Whole Genome Sequencing.
> > 3. Yes, there are differences. It's a different set of primers. The reason for this very different result are the settings of the parameters. In the last run, we let VarVamp run with the default settings for the tiled flavor. Check out the analysis/varvamp log file of both, the one on the github website and your own produced.
> > 4. Increase of length of amplicon, minimal required overlap and threshold or decrease of maximum number of ambiguous nucleotides per primer.
> >
> {: .solution}
>
{: .question}

# Conclusion

Creating primers for further gene analysis is essential. VarVAMP delivers a possibility to design highly divers and personally specified primers and even the option to eliminate off-targets thanks to a BLAST database. In combination with MAFFT, a strongly adjustable multiple alignment tool, it is possible to search for similar genome sequences in a sample batch and if there have viral origin, be able to do preparatory work for the amplification technique of interest. This Galaxy workflow is therefore extremely useful for applications such as the identification of related virus genomes.
