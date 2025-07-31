---
layout: tutorial_hands_on

title: Modeling Breast Cancer Subtypes using Flexynesis
zenodo_link: https://zenodo.org/records/16287482
questions:
- Which biological questions are addressed by the tutorial?
- Which bioinformatics techniques are important to know for this type of data?
objectives:
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
contributors:
- contributor1
- contributor2

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
>    https://zenodo.org/api/records/16287482/files/train_mut_lgggbm.tabular/content
>    https://zenodo.org/api/records/16287482/files/test-ADT_BMscRNAseq.tabular/content
>    https://zenodo.org/api/records/16287482/files/train-clin_BMscRNAseq.tabular/content
>    https://zenodo.org/api/records/16287482/files/train-RNA_BMscRNAseq.tabular/content
>    https://zenodo.org/api/records/16287482/files/train_clin_lgggbm.tabular/content
>    https://zenodo.org/api/records/16287482/files/test_cna_lgggbm.tabular/content
>    https://zenodo.org/api/records/16287482/files/train_cna_lgggbm.tabular/content
>    https://zenodo.org/api/records/16287482/files/test_mut_lgggbm.tabular/content
>    https://zenodo.org/api/records/16287482/files/test_clin_lgggbm.tabular/content
>    https://zenodo.org/api/records/16287482/files/train_cna_brca.tabular/content
>    https://zenodo.org/api/records/16287482/files/test-clin_BMscRNAseq.tabular/content
>    https://zenodo.org/api/records/16287482/files/train-ADT_BMscRNAseq.tabular/content
>    https://zenodo.org/api/records/16287482/files/test-RNA_BMscRNAseq.tabular/content
>    https://zenodo.org/api/records/16287482/files/train_mut_brca.tabular/content
>    https://zenodo.org/api/records/16287482/files/test_mut_brca.tabular/content
>    https://zenodo.org/api/records/16287482/files/train_clin_brca.tabular/content
>    https://zenodo.org/api/records/16287482/files/test_cna_brca.tabular/content
>    https://zenodo.org/api/records/16287482/files/train_gex_brca.tabular/content
>    https://zenodo.org/api/records/16287482/files/test_gex_brca.tabular/content
>    https://zenodo.org/api/records/16287482/files/test_clin_brca.tabular/content
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
>    - *"Type of Analysis"*: `Supervised training`
>        - {% icon param-file %} *"Training clinical data"*: `output` (Input dataset)
>        - {% icon param-file %} *"Test clinical data"*: `output` (Input dataset)
>        - {% icon param-file %} *"Training omics data"*: `output` (Input dataset)
>        - {% icon param-file %} *"Test omics data"*: `output` (Input dataset)
>        - *"What type of assay is your input?"*: `gex`
>        - In *"Multiple omics layers?"*:
>            - {% icon param-repeat %} *"Insert Multiple omics layers?"*
>                - {% icon param-file %} *"Training omics data"*: `output` (Input dataset)
>                - *"What type of assay is your input?"*: `cna`
>        - *"Model class"*: `DirectPred`
>        - *"Column name in the train clinical data to use for predictions, multiple targets are allowed"*: `c['16']`
>        - In *"Advanced Options"*:
>            - *"Variance threshold (as percentile) to drop low variance features."*: `0.8`
>            - *"Minimum number of features to retain after feature selection."*: `100`
>            - *"Top percentile features (among the features remaining after variance filtering and data cleanup) to retain after feature selection."*: `10.0`
>            - *"Number of iterations for hyperparameter optimization."*: `1`
>        - In *"Visualization"*:
>            - *"Generate embeddings plot?"*: `Yes`
>            - *"Generate kaplan meier curves plot?"*: `No`
>            - *"Generate hazard ratio plot?"*: `No`
>            - *"Generate scatter plot?"*: `No`
>            - *"Generate concordance heatmap plot?"*: `No`
>            - *"Generate precision-recall curves plot?"*: `No`
>            - *"Generate ROC curves plot?"*: `No`
>            - *"Generate boxplot?"*: `No`
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
>    - *"How should a dataset be selected?"*: `Select by element identifier`
>        - *"Element identifier:"*: `job.embeddings_test`
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
>    - *"How should a dataset be selected?"*: `Select by element identifier`
>        - *"Element identifier:"*: `job.predicted_labels`
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

## Sub-step with **Sort**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Sort](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_sort_header_tool/9.5+galaxy2) %} with the following parameters:
>    - *"Number of header lines"*: `1`
>    - In *"Column selections"*:
>        - {% icon param-repeat %} *"Insert Column selections"*
>            - *"on column"*: `c1`
>    - *"Output unique values"*: `Yes`
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
>        - {% icon param-file %} *"Predicted labels"*: `outfile` (output of **Sort** {% icon tool %})
>        - *"Column in the labels file to use for coloring the points in the plot"*: `c5`
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