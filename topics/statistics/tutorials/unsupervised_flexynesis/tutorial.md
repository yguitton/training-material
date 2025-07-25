---
layout: tutorial_hands_on

title: Unsupervised Analysis of Bone Marrow Cells with Flexynesis
zenodo_link: 'https://zenodo.org/records/16287482'
questions:
- How can we identify distinct cell populations in bone marrow single-cell data without prior labels?
- What cellular patterns and relationships can be discovered through unsupervised deep learning approaches?
- How does variational autoencoder (VAE) architecture help in dimensionality reduction and feature learning for single-cell data?
objectives:
- Apply Flexynesis VAE architecture for unsupervised analysis of single-cell bone marrow data
- Perform dimensionality reduction and feature learning using deep learning methods
- Identify and interpret cellular clusters and patterns in high-dimensional single-cell datasets
- Evaluate the quality of unsupervised representations through visualization and clustering metrics
time_estimation: ?H
key_points:
- Variational autoencoders can effectively capture cellular heterogeneity in single-cell data without requiring labeled training data
- TFlexynesis provides a structured framework for multi-modal data integration with rigorous evaluation procedures
- Unsupervised feature learning can reveal biologically meaningful cellular populations and relationships
- Low-dimensional embeddings from VAEs can be used for clustering, visualization, and biological interpretation
contributors:
- nilchia
- bgruening

---



General introduction about the topic and then an introduction of the
tutorial (the questions and the objectives). It is nice also to have a
scheme to sum up the pipeline used during the tutorial. The idea is to
give to trainees insight into the content of the tutorial and the (theoretical
and technical) key concepts they will learn.

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

<!-- This is a comment. -->

**Please follow our
[tutorial to learn how to fill the Markdown]({{ site.baseurl }}/topics/contributing/tutorials/create-new-tutorial-content/tutorial.html)**

> <agenda-title></agenda-title>
>
> In this tutorial, we will cover:
>
> 1. TOC
> {:toc}
>
{: .agenda}

# Title for your first section

Give some background about what the trainees will be doing in the section.
Remember that many people reading your materials will likely be novices,
so make sure to explain all the relevant concepts.

## Title for a subsection
Section and subsection titles will be displayed in the tutorial index on the left side of
the page, so try to make them informative and concise!

# Hands-on Sections
Below are a series of hand-on boxes, one for each tool in your workflow file.
Often you may wish to combine several boxes into one or make other adjustments such
as breaking the tutorial into sections, we encourage you to make such changes as you
see fit, this is just a starting point :)

Anywhere you find the word "***TODO***", there is something that needs to be changed
depending on the specifics of your tutorial.

have fun!

## Get data

> <hands-on-title> Data Upload </hands-on-title>
>
> 1. Create a new history for this tutorial
> 2. Import the files from [Zenodo]({{ page.zenodo_link }}) or from
>    the shared data library (`GTN - Material` -> `{{ page.topic_name }}`
>     -> `{{ page.title }}`):
>
>    ```
>
>    ```
>    ***TODO***: *Add the files by the ones on Zenodo here (if not added)*
>
>    ***TODO***: *Remove the useless files (if added)*
>
>    {% snippet faqs/galaxy/datasets_import_via_link.md %}
>
>    {% snippet faqs/galaxy/datasets_import_from_data_library.md %}
>
> 3. Rename the datasets
> 4. Check that the datatype
>
>    {% snippet faqs/galaxy/datasets_change_datatype.md datatype="datatypes" %}
>
> 5. Add to each database a tag corresponding to ...
>
>    {% snippet faqs/galaxy/datasets_add_tag.md %}
>
{: .hands_on}

# Title of the section usually corresponding to a big step in the analysis

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


## Sub-step with **Flexynesis**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Flexynesis](toolshed.g2.bx.psu.edu/repos/bgruening/flexynesis/flexynesis/0.2.20+galaxy3) %} with the following parameters:
>    - *"I certify that I am not using this tool for commercial purposes."*: `Yes`
>    - *"Type of Analysis"*: `Unsupervised Training`
>        - {% icon param-file %} *"Training clinical data"*: `output` (Input dataset)
>        - {% icon param-file %} *"Test clinical data"*: `output` (Input dataset)
>        - {% icon param-file %} *"Training omics data"*: `output` (Input dataset)
>        - {% icon param-file %} *"Test omics data"*: `output` (Input dataset)
>        - *"What type of assay is your input?"*: `RNA`
>        - In *"Multiple omics layers?"*:
>            - {% icon param-repeat %} *"Insert Multiple omics layers?"*
>                - {% icon param-file %} *"Training omics data"*: `output` (Input dataset)
>                - *"What type of assay is your input?"*: `ADT`
>        - In *"Advanced Options"*:
>            - *"How many epochs to wait when no improvements in validation loss are observed."*: `5`
>            - *"Number of iterations for hyperparameter optimization."*: `1`
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

## Sub-step with **Extract dataset**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Extract dataset](__EXTRACT_DATASET__) %} with the following parameters:
>    - {% icon param-file %} *"Input List"*: `results` (output of **Flexynesis** {% icon tool %})
>    - *"How should a dataset be selected?"*: `The first dataset`
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

## Sub-step with **Flexynesis utils**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Flexynesis utils](toolshed.g2.bx.psu.edu/repos/bgruening/flexynesis_utils/flexynesis_utils/0.2.20+galaxy3) %} with the following parameters:
>    - *"I certify that I am not using this tool for commercial purposes."*: `Yes`
>    - *"Flexynesis utils"*: `Louvain Clustering`
>        - {% icon param-file %} *"Predicted labels"*: `output` (Input dataset)
>        - *"Number of nearest neighbors to connect for each node"*: `15`
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

## Sub-step with **Flexynesis plot**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Flexynesis plot](toolshed.g2.bx.psu.edu/repos/bgruening/flexynesis_plot/flexynesis_plot/0.2.20+galaxy3) %} with the following parameters:
>    - *"I certify that I am not using this tool for commercial purposes."*: `Yes`
>    - *"Flexynesis plot"*: `Dimensionality reduction`
>        - {% icon param-file %} *"Predicted labels"*: `output` (Input dataset)
>        - *"Column in the labels file to use for coloring the points in the plot"*: `c10`
>        - *"Transformation method"*: `UMAP`
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

## Sub-step with **Flexynesis utils**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Flexynesis utils](toolshed.g2.bx.psu.edu/repos/bgruening/flexynesis_utils/flexynesis_utils/0.2.20+galaxy3) %} with the following parameters:
>    - *"I certify that I am not using this tool for commercial purposes."*: `Yes`
>    - *"Flexynesis utils"*: `Get Optimal Clusters`
>        - {% icon param-file %} *"Predicted labels"*: `util_out` (output of **Flexynesis utils** {% icon tool %})
>        - *"Minimum number of clusters to try"*: `10`
>        - *"Maximum number of clusters to try"*: `20`
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

## Sub-step with **Flexynesis plot**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Flexynesis plot](toolshed.g2.bx.psu.edu/repos/bgruening/flexynesis_plot/flexynesis_plot/0.2.20+galaxy3) %} with the following parameters:
>    - *"I certify that I am not using this tool for commercial purposes."*: `Yes`
>    - *"Flexynesis plot"*: `Label concordance heatmap`
>        - {% icon param-file %} *"Predicted labels"*: `util_out` (output of **Flexynesis utils** {% icon tool %})
>        - *"Column in the labels file to use for true labels"*: `c10`
>        - *"Column in the labels file to use for predicted labels"*: `c12`
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

## Sub-step with **Flexynesis utils**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Flexynesis utils](toolshed.g2.bx.psu.edu/repos/bgruening/flexynesis_utils/flexynesis_utils/0.2.20+galaxy3) %} with the following parameters:
>    - *"I certify that I am not using this tool for commercial purposes."*: `Yes`
>    - *"Flexynesis utils"*: `Compute AMI and ARI`
>        - {% icon param-file %} *"Predicted labels"*: `util_out` (output of **Flexynesis utils** {% icon tool %})
>        - *"Column name in the labels file to use for the true labels"*: `c10`
>        - *"Column name in the labels file to use for the predicted labels"*: `c12`
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

## Sub-step with **Flexynesis utils**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Flexynesis utils](toolshed.g2.bx.psu.edu/repos/bgruening/flexynesis_utils/flexynesis_utils/0.2.20+galaxy3) %} with the following parameters:
>    - *"I certify that I am not using this tool for commercial purposes."*: `Yes`
>    - *"Flexynesis utils"*: `Compute AMI and ARI`
>        - {% icon param-file %} *"Predicted labels"*: `util_out` (output of **Flexynesis utils** {% icon tool %})
>        - *"Column name in the labels file to use for the true labels"*: `c10`
>        - *"Column name in the labels file to use for the predicted labels"*: `c13`
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

## Sub-step with **Flexynesis plot**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Flexynesis plot](toolshed.g2.bx.psu.edu/repos/bgruening/flexynesis_plot/flexynesis_plot/0.2.20+galaxy3) %} with the following parameters:
>    - *"I certify that I am not using this tool for commercial purposes."*: `Yes`
>    - *"Flexynesis plot"*: `Dimensionality reduction`
>        - {% icon param-file %} *"Predicted labels"*: `util_out` (output of **Flexynesis utils** {% icon tool %})
>        - *"Column in the labels file to use for coloring the points in the plot"*: `c12`
>        - *"Transformation method"*: `UMAP`
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