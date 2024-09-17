---
layout: tutorial_hands_on

title: Molecular formula assignment and recalibration with MFAssignR package
zenodo_link: https://zenodo.org/records/13768009
questions:
- What are the main steps of untargeted metabolomics LC-MS data pre-processing?
- How to analyze complex mixture samples using the MFAssignR package?
objectives:
- To learn about the main steps in the pre-processing of untargeted metabolomics LC-MS data.
- To try on-hands analysis using the model data.

time_estimation: 3H
key_points:
- The take-home messages
- They will appear at the end of the tutorial
contributors:
- Kristina Gomoryova
- hechth

---

This training covers the multi-element molecular formula (MF) assignment using the MFAssignR tool. It was originally developed by {% cite Schum2020 %} and contains several functions including noise assessment, isotope filtering, internal mass recalibration and formula assignment. 

MFAssignR workflow is composed of several steps:

1. Run KMDNoise() to determine the noise level for the data.
2. Check effectiveness of S/N threshold using SNplot().
3. Use IsoFiltR() to identify potential 13C and 34S isotope masses.
4. Using the S/N threshold, and the two data frames output from IsoFiltR(), run MFAssignCHO() to assign MF with C, H, and O to assess the mass accuracy.
5. Use RecalList() to generate a list of the potential recalibrant series.
6. After choosing recalibrant series, use Recal() to recalibrate the mass lists.
7. Assign MF to the recalibrated mass list using MFAssign().
8. Check the output plots from MFAssign() to evaluate the quality of the assignments.

Let's dive now into the individual steps and explain all the inputs, parameter settings and outputs.

> <agenda-title></agenda-title>
>
> In this tutorial, we will cover:
>
> 1. TOC
> {:toc}
>
{: .agenda}

# Data import

At the very beginning, we need to import the dataset we will be using. MFAssignR requires an input data, which have as the first column mass, in the second column there is intensity and optionally, the third column can contain retention time. In our case, we will start with a raw mass list, which was measured in a negative ESI mode.

> <hands-on-title> Upload data </hands-on-title>
>
> 1. Create a new history for this tutorial and give it a name.
>
>    {% snippet faqs/galaxy/histories_create_new.md %}
>
> 2. Import the files from [Zenodo]({{ https://zenodo.org/records/13768009 }}):
>
>    ```
>    https://zenodo.org/api/records/13768009/files/mfassignr_input.txt/content
>    ```
>
>    {% snippet faqs/galaxy/datasets_import_via_link.md %}
>
>    {% snippet faqs/galaxy/datasets_import_from_data_library.md %}
>
> 3. Set the format of the dataset to 'tabular'. 
>
>    {% snippet faqs/galaxy/datasets_change_datatype.md datatype="tabular" %}
>
> 4. We can now view our dataset, and ensure, that it has a correct input format.
>
>
{: .hands_on}

# Noise assessment

Having our input data in the workspace, we can now start with the analysis!

The first step is the noise assessment, which allows us to avoid both false positives (if noise is underestimated) and false negatives (if noise is overestimated). For this purpose, we will be using two functions: MFAssignR HistNoise and MFAssignR KMDNoise, and we can additionally visualize the result using the MFAssignR SNplot function. The main goal is to find a signal-to-noise (S/N) threshold, which we will use later on. 

## Sub-step with **MFAssignR KMDNoise**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [MFAssignR KMDNoise](toolshed.g2.bx.psu.edu/repos/recetox/mfassignr_kmdnoise/mfassignr_kmdnoise/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Input data"*: `output` (Input dataset)
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

## Sub-step with **MFAssignR HistNoise**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [MFAssignR HistNoise](toolshed.g2.bx.psu.edu/repos/recetox/mfassignr_histnoise/mfassignr_histnoise/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Input data"*: `output` (Input dataset)
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

## Sub-step with **MFAssignR SNplot**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [MFAssignR SNplot](toolshed.g2.bx.psu.edu/repos/recetox/mfassignr_snplot/mfassignr_snplot/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Input data"*: `output` (Input dataset)
>    - *"cut"*: `2076.0`
>    - *"mass"*: `301.0`
>    - *"window.x"*: `50.0`
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

## Sub-step with **MFAssignR IsoFiltR**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [MFAssignR IsoFiltR](toolshed.g2.bx.psu.edu/repos/recetox/mfassignr_isofiltr/mfassignr_isofiltr/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Input Peak Data"*: `output` (Input dataset)
>    - *"Signal-to-Noise Ratio"*: `346.0`
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

## Sub-step with **MFAssignR MFAssignCHO**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [MFAssignR MFAssignCHO](toolshed.g2.bx.psu.edu/repos/recetox/mfassignr_mfassigncho/mfassignr_mfassignCHO/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Data frame of monoisotopic masses"*: `mono_out` (output of **MFAssignR IsoFiltR** {% icon tool %})
>    - {% icon param-file %} *"Data frame of isotopic masses"*: `iso_out` (output of **MFAssignR IsoFiltR** {% icon tool %})
>    - *"Ion mode"*: `negative`
>    - *"Estimated noise"*: `346.0`
>    - *"Lower limit of molecular mass to be assigned"*: `50.0`
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

## Sub-step with **MFAssignR RecalList**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [MFAssignR RecalList](toolshed.g2.bx.psu.edu/repos/recetox/mfassignr_recallist/mfassignr_recallist/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Input data"*: `Unambig` (output of **MFAssignR MFAssignCHO** {% icon tool %})
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

## Sub-step with **MFAssignR FindRecalSeries**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [MFAssignR FindRecalSeries](mfassignr_findRecalSeries) %} with the following parameters:
>    - {% icon param-file %} *"Input data"*: `recal_series` (output of **MFAssignR RecalList** {% icon tool %})
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

## Sub-step with **MFAssignR Recal**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [MFAssignR Recal](toolshed.g2.bx.psu.edu/repos/recetox/mfassignr_recal/mfassignr_recal/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Input data (Output from MFAssign)"*: `Unambig` (output of **MFAssignR MFAssignCHO** {% icon tool %})
>    - {% icon param-file %} *"Calibration series (Output from RecalList)"*: `final_series` (output of **MFAssignR FindRecalSeries** {% icon tool %})
>    - {% icon param-file %} *"Peaks dataframe (Mono from IsoFiltR)"*: `mono_out` (output of **MFAssignR IsoFiltR** {% icon tool %})
>    - {% icon param-file %} *"Isopeaks dataframe (Iso from IsoFiltR)"*: `iso_out` (output of **MFAssignR IsoFiltR** {% icon tool %})
>    - *"Ion mode"*: `negative`
>    - *"Estimated noise"*: `346.0`
>    - *"Mass windows used for the segmented recalibration"*: `50.0`
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

## Sub-step with **MFAssignR MFAssign**

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [MFAssignR MFAssign](toolshed.g2.bx.psu.edu/repos/recetox/mfassignr_mfassign/mfassignr_mfassign/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Data frame of monoisotopic masses"*: `Mono` (output of **MFAssignR Recal** {% icon tool %})
>    - {% icon param-file %} *"Data frame of isotopic masses"*: `Iso` (output of **MFAssignR Recal** {% icon tool %})
>    - *"Ion mode"*: `negative`
>    - *"Estimated noise"*: `346.0`
>    - *"Lower limit of molecular mass to be assigned"*: `50.0`
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