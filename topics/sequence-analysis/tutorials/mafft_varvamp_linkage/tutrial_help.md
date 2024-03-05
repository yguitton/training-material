---
layout: tutorial_hands_on

title: HELP INCLUDED - Primer design of related virus genomes
level: Introductory
zenodo_link: ''
questions:
- How can primers for related viruses of a pool of different virus genomes for further PCR be obtained?
- What kind of different multiple sequence alignment methods can be used to analyze my virus genome data?
- How can the primer design be adjusted, to get the best fitting primers for further sequencing?

- Which bioinformatics techniques?
- sequence alignment/multiple sequence alignment
- primer design

objectives:
- Run the workflow to summarize and analyse related virus genomes with different alignment methods in a sample batch
- Run the workflow to generate primers for different sequencing techniques

- The learning objectives are the goals of the tutorial
- They will be informed by your audience and will communicate to them and to yourself
  what you should focus on during the course
- They are single sentences describing what a learner should be able to do once they
  have completed the tutorial
- You can use Bloom's Taxonomy to write effective learning objectives
time_estimation: 3H
key_points:
- The take-home messages
- They will appear at the end of the tutorial
requirements:
-
    type: "internal"
    topic_name: galaxy-interface
    tutorials:
        - collections
contributors:
- contributor1
- contributor2
tags:
- virology
---


For studying viruses it is necessary to have the option to sequence and reproduce the viral genomes in specific parts or as a whole. Multiple alignment sequencing makes it possible to search for relation of viral genomes in datasets of samples and helps to isolate single families. In order to multiply these related gene sequences, a new tool named VarVAMP, assists in designing primers for further sequencing, such as PCR or whole genome sequencing.

This training shows the application and understanding of the tools MAFFT, a multifunctional alignement tool for nucleic and amino acid sequences, and VarVAMP, a primer design tool for viruses with a broad functionality in terms of tool adjustements or different types of output generation. The combination of these two provides a automation of finding related virus sequences in data with producing fitting primers for amplification.

scheme?
further theoretical concepts?

<!-- This is a comment. -->

You may want to cite some publications; this can be done by adding citations to the
bibliography file (`tutorial.bib` file next to your `tutorial.md` file). These citations
must be in bibtex format. If you have the DOI for the paper you wish to cite, you can
get the corresponding bibtex entry using [doi2bib.org](https://doi2bib.org).

With the example you will find in the `tutorial.bib` file, you can add a citation to
this article here in your tutorial like this:
{% raw %} `{% cite Batut2018 %}`{% endraw %}.
This will be rendered like this: {% cite Batut2018 %}, and links to a
[bibliography section](#bibliography) which will automatically be created at the end of the
tutorial.


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

- background what will be done in the section, explain concepts!

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
> - Alternatively, 
{: .comment}

## Hands-on Sections
Below are a series of hand-on boxes, one for each tool in your workflow file.


> <hands-on-title> Data Upload </hands-on-title>
>
> - Option 1: Zenodo
>    2. Import the files from [Zenodo]({{ page.zenodo_link }}) <!--or from
>    the shared data library (`GTN - Material` -> `{{ page.topic_name }}`
>     -> `{{ page.title }}`):-->
>
>    ```
>    ```
>   ***TODO***: *Add the files by the ones on Zenodo here (if not added)* 
>       {% snippet faqs/galaxy/datasets_import_via_link.md %}
>   3. Rename the datasets
>   4. Check that the datatype 
>       {% snippet faqs/galaxy/datasets_change_datatype.md datatype="datatypes" %}
>   5. Add to each database a tag corresponding to ... 
>   6. {% snippet faqs/galaxy/datasets_add_tag.md %}
>
> - Option 2: Import your own data
>   
>   1. das
>   2. das
>   3. das
>
>
>
>
>
>
{: .hands_on}

# 1Multiple alignment of nucleic sequences with **MAFFT**

It comes first a description of the step: some background and some theory.
Some image can be added there to support the theory explanation:

![Alternative text](../../images/image_name "Legend of the image")

The idea is to keep the theory description before quite simple to focus more on the practical part.

***TODO***: *Consider adding a detail box to expand the theory*

> <details-title> More details about the theory </details-title>
>
> But to describe more details, it is possible to use the detail boxes which are expandable
>
{: .details}

A big step can have several subsections or sub steps:

## Input
## Setting
> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [MAFFT](toolshed.g2.bx.psu.edu/repos/rnateam/mafft/rbc_mafft/7.508+galaxy1) %} with the following parameters:
>    - {% icon param-file %} *"Sequences to align"*: `output` (Input dataset)
>    - *"Data type"*: `Nucleic acids`
>    - *"MAFFT flavour"*: `fftns`
>    - *"Matrix selection"*: `BLOSUM`
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
## Output
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

# Primer design with **VarVAMP**

## Input
## Settings
> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [varVAMP](toolshed.g2.bx.psu.edu/repos/iuc/varvamp/varvamp/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Multiple alignment of viral sequences"*: `outputAlignment` (output of **MAFFT** {% icon tool %})
>    - *"What kind of primers would you like to design? (varvamp mode)"*: `Primers for single amplicons (single)`
>        - *"How to set the main parameters, threshold for consensus nucleotides and max ambiguous nts per primer?"*: `Specify max ambiguous nts, estimate suitable threshold`
>        - *"Optimal length of the amplicons"*: `600`
>        - *"Maximal length of the amplicons"*: `1000`
>        - *"Avoid amplicons with off-target primer products?"*: `No, don't consider off-target products`
>        - *"Limit the number of amplicons to report?"*: `No, report all qualifying amplicons`
>        - *"Customize Advanced Settings?"*: `No, use defaults for advanced settings`
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

## Output
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
