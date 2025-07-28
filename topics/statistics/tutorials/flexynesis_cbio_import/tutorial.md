---
layout: tutorial_hands_on

title: Prepare data from CbioPortal for Flexynesis integration
zenodo_link: https://zenodo.org/records/16287482
questions:
- How to download data from cBioPortal?
- How to prepare omics data for Flexynesis integration.
objectives:
- Download Breast cancer data from Metabric through cBioportal using Flexynesis
- Clean and preprocess genomics data
- Format data for downstream integration analysis
time_estimation: 1H
key_points:
- cBioportal is a repository for accessible and interpretable cancer genomic data
- Flexynesis comprehensive tool can be used to make data ready for integration.
contributors:
- Nilchia
- bgruening

---

The cBioPortal is an open-access web platform that provides intuitive access to large-scale cancer genomics datasets {% cite Gao2013 %} {% cite cbioportal-website %}. Originally developed to make complex molecular profiling data more accessible to the broader research community, cBioPortal hosts data from thousands of cancer studies and tens of thousands of tumor samples.

In this tutorial, we will work with data from the METABRIC consortium {% cite metabric-website %}, one of the landmark breast cancer genomics studies available through cBioPortal. This dataset contains comprehensive molecular and clinical data from over 2,000 breast cancer patients, including gene expression profiles, copy number alterations, mutation data, and clinical outcomes.

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


## Sub-step with **Extract dataset**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Extract dataset](__EXTRACT_DATASET__) %} with the following parameters:
>    - {% icon param-file %} *"Input List"*: `data` (output of **Flexynesis cBioPortal import** {% icon tool %})
>    - *"How should a dataset be selected?"*: `Select by element identifier`
>        - *"Element identifier:"*: `data_mrna_illumina_microarray`
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
>    - {% icon param-file %} *"Input List"*: `data` (output of **Flexynesis cBioPortal import** {% icon tool %})
>    - *"How should a dataset be selected?"*: `Select by element identifier`
>        - *"Element identifier:"*: `data_mutations`
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
>    - {% icon param-file %} *"Input List"*: `data` (output of **Flexynesis cBioPortal import** {% icon tool %})
>    - *"How should a dataset be selected?"*: `Select by element identifier`
>        - *"Element identifier:"*: `data_clinical_patient`
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
>    - {% icon param-file %} *"Sort Query"*: `output` (output of **Extract dataset** {% icon tool %})
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

## Sub-step with **Table Compute**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Table Compute](toolshed.g2.bx.psu.edu/repos/iuc/table_compute/table_compute/1.2.4+galaxy2) %} with the following parameters:
>    - *"Input Single or Multiple Tables"*: `Single Table`
>        - {% icon param-file %} *"Table"*: `output` (output of **Extract dataset** {% icon tool %})
>        - In *"Advanced File Options "*:
>            - *"Header begins at line N"*: `1`
>        - *"Type of table operation"*: `No operation (just reformat on output)`
>    - *"Output formatting options"*: ``
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

## Sub-step with **Table Compute**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Table Compute](toolshed.g2.bx.psu.edu/repos/iuc/table_compute/table_compute/1.2.4+galaxy2) %} with the following parameters:
>    - *"Input Single or Multiple Tables"*: `Single Table`
>        - {% icon param-file %} *"Table"*: `output` (output of **Extract dataset** {% icon tool %})
>        - In *"Advanced File Options "*:
>            - *"Header begins at line N"*: `4`
>        - *"Type of table operation"*: `No operation (just reformat on output)`
>    - *"Output formatting options"*: ``
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

## Sub-step with **Advanced Cut**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Advanced Cut](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_cut_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"File to cut"*: `outfile` (output of **Sort** {% icon tool %})
>    - *"Operation"*: `Discard`
>    - *"Cut by"*: `fields`
>        - *"Is there a header for the data's columns ?"*: `Yes`
>            - *"List of Fields"*: `c['2']`
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

## Sub-step with **Advanced Cut**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Advanced Cut](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_cut_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"File to cut"*: `table` (output of **Table Compute** {% icon tool %})
>    - *"Operation"*: `Discard`
>    - *"Cut by"*: `fields`
>        - *"Is there a header for the data's columns ?"*: `Yes`
>            - *"List of Fields"*: `c['1']`
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

## Sub-step with **Advanced Cut**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Advanced Cut](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_cut_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"File to cut"*: `table` (output of **Table Compute** {% icon tool %})
>    - *"Operation"*: `Discard`
>    - *"Cut by"*: `fields`
>        - *"Is there a header for the data's columns ?"*: `Yes`
>            - *"List of Fields"*: `c['1']`
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
>    - *"Flexynesis utils"*: `Binarize mutation data`
>        - {% icon param-file %} *"Mutation data"*: `output` (output of **Advanced Cut** {% icon tool %})
>        - *"Column in the mutation file with genes"*: `c1`
>        - *"Column in the mutation file with samples"*: `c17`
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
> 1. {% tool [Flexynesis utils](toolshed.g2.bx.psu.edu/repos/bgruening/flexynesis_utils/flexynesis_utils/0.2.20+galaxy2) %} with the following parameters:
>    - *"I certify that I am not using this tool for commercial purposes."*: `Yes`
>    - *"Flexynesis utils"*: `Split data to train and test`
>        - {% icon param-file %} *"Clinical data"*: `output` (output of **Advanced Cut** {% icon tool %})
>        - {% icon param-files %} *"Omics data"*: `output` (output of **Advanced Cut** {% icon tool %}), `util_out` (output of **Flexynesis utils** {% icon tool %})
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