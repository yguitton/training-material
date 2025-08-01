---
layout: tutorial_hands_on

title: Modeling Breast Cancer Subtypes using Flexynesis
zenodo_link: https://zenodo.org/records/16287482
questions:
- How can we model breast cancer subtypes using transcriptomic and genomic data?
- What are the key expression patterns that distinguish different BRCA subtypes?
- How can we interpret the latent space learned by a variational autoencoder?
objectives:
- Apply Flexynesis to model and visualize BRCA subtypes
- Interpret the latent representations learned by the model
- Use UMAP and clustering to explore learned features
time_estimation: 2H
key_points:
- Flexynesis learns biologically meaningful latent spaces
- BRCA subtypes can be distinguished using learned features
contributors:
- Nilchia
- bgruening

---

Flexynesis represents a state-of-the-art deep learning framework specifically designed for multi-modal data integration in biological research ({% cite Uyar2024 %}). What sets Flexynesis apart is its comprehensive suite of deep learning architectures, including supervised and unsupervised VAEs, that can handle various data integration scenarios while providing robust feature selection and hyperparameter optimization.

Here, we use Flexynesis tool suite on a multi-omic dataset of Breast Cancer samples from the METABRIC consortium ({% cite metabric-website %}), one of the landmark breast cancer genomics studies available through cBioPortal ({% cite cbioportal-website %}). This dataset contains comprehensive molecular and clinical data from over 2,000 breast cancer patients, including gene expression profiles, copy number alterations, mutation data, and clinical outcomes. The data was downloaded from Cbioportal and randomly split into train (70% of the samples) and test (30% of the samples) data folders. The data files were processed to follow the same nomenclature.

This training is inspired from the original flexynesis analysis notebook: [brca_subtypes.ipynb](https://github.com/BIMSBbioinfo/flexynesis/blob/main/examples/tutorials/brca_subtypes.ipynb).

> <warning-title>LICENSE</warning-title>
>
>Flexynesis is only available for NON-COMMERCIAL use. Permission is only granted for academic, research, and educational purposes. Before using, be sure to review, agree, and comply with the license.
>For commercial use, please review the flexynesis license on GitHub and contact the [copyright holders](https://github.com/BIMSBbioinfo/flexynesis)
{: .warning}

> <agenda-title></agenda-title>
>
> In this tutorial, we will cover:
>
> 1. TOC
> {:toc}
>
{: .agenda}

# Get data

> <hands-on-title> Data Upload </hands-on-title>
>
> 1. Create a new history for this tutorial
> 2. Import the files from [Zenodo]({{ page.zenodo_link }}) or from
>    the shared data library (`GTN - Material` -> `{{ page.topic_name }}`
>     -> `{{ page.title }}`):
>
>    ```
>    https://zenodo.org/api/records/16287482/files/train_cna_brca.tabular
>    https://zenodo.org/api/records/16287482/files/train_gex_brca.tabular
>    https://zenodo.org/api/records/16287482/files/train_clin_brca.tabular
>    https://zenodo.org/api/records/16287482/files/test_cna_brca.tabular
>    https://zenodo.org/api/records/16287482/files/test_gex_brca.tabular
>    https://zenodo.org/api/records/16287482/files/test_clin_brca.tabular
>    ```
>
>    {% snippet faqs/galaxy/datasets_import_via_link.md %}
>
>    {% snippet faqs/galaxy/datasets_import_from_data_library.md %}
>
> 3. Rename the datasets
> 4. Check that the datatype is `tabular`
>
>    {% snippet faqs/galaxy/datasets_change_datatype.md datatype="tabular" %}
>
> 5. Add to each database a tag corresponding to the modality (#gex, #cna, #clin)
>
>    {% snippet faqs/galaxy/datasets_add_tag.md %}
>
{: .hands_on}


## Classification task with Flexynesis

Flexynesis automatically handles key preprocessing steps such as:

* Data processing:
  * removing uninformative features (e.g. features with near-zero-variation)
  * removing samples with too many NA values
  * removing features with too many NA values and impute NA values for the rest with few NA values

* Feature selection **only on training data** for each omics layer separately:
  * Features are sorted by Laplacian score
  * Features that make it in the `top_percentile`
  * Highly redundant features are further removed (for a pair of highly correlated features, keep the one with the higher laplacian score).

* Harmonize the training data with the test data

* Normalize the datasets (Subset the test data features to those that are kept for training data)

* Normalize training data (standard scaling) and apply the same scaling factors to the test data.

* Log transform the final matrices (Optional)

* Distinguish numerical and categorical variables in the clinical data file. For categorical variables, create a numerical encoding of the labels for training data. Use the same encoders to map the test samples to the same numerical encodings.

>    > <comment-title> No manual preprocessing is required </comment-title>
>    >
>    > Flexynesis performs all data cleaning internally as part of its pipeline.
>    {: .comment}

> <hands-on-title> Task description </hands-on-title>
>
> 1. {% tool [Flexynesis](toolshed.g2.bx.psu.edu/repos/bgruening/flexynesis/flexynesis/0.2.20+galaxy3) %} with the following parameters:
>    - *"I certify that I am not using this tool for commercial purposes."*: `Yes`
>    - *"Type of Analysis"*: `Supervised training`
>        - {% icon param-file %} *"Training clinical data"*: `train_clin_brca.tabular`
>        - {% icon param-file %} *"Test clinical data"*: `test_clin_brca.tabular`
>        - {% icon param-file %} *"Training omics data"*: `train_gex_brca.tabular`
>        - {% icon param-file %} *"Test omics data"*: `test_gex_brca.tabular`
>        - *"What type of assay is your input?"*: `gex`
>        - In *"Multiple omics layers?"*:
>            - {% icon param-repeat %} *"Insert Multiple omics layers?"*
>                - {% icon param-file %} *"Training omics data"*: `train_cna_brca.tabular`
>        - {% icon param-file %} *"Test clinical data"*: `test_cna_brca.tabular`
>                - *"What type of assay is your input?"*: `cna`
>        - *"Model class"*: `DirectPred`
>        - *"Column name in the train clinical data to use for predictions, multiple targets are allowed"*: `Column: 16`
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
{: .hands_on}

> <question-title></question-title>
>
> 1. What are main outputs of Flexynesis?
> 2. What does the generated plots show?
> 3. What information is in `job.stats` output?
> 4. What are top 10 features in `job.feature_importance.GradientShap`?
>
> > <solution-title></solution-title>
> >
> > 1. The results collection contains the following data:
> > * job.embeddings_test (latent space of test data)
> > * job.embeddings_train (latent space of train data)
> > * job.feature_importance.GradientShap (feature importance calculated by GradientShap method)
> > * job.feature_importance.IntegratedGradients (feature importance calculated by IntegratedGradients method)
> > * job.feature_logs.cna
> > * job.feature_logs.mut
> > * job.predicted_labels (Prediction of the created model)
> > * job.stats
> >
> > 2. There are two figures in plot collection:
> > * The first plot is the Kaplan Meier Curves of the risk subtypes.
> > * The second plot is a forest plot of calculated Cox-PH model of top 5 markers.
> >
> > 3. It shows that we achieved a reasonable performance of Harrell's Concordance Index (C-index) on test data.
> >
> > 4. *IDH2*, *IDH1*, *HIVEP3*, *PIK3CA*, *EGFR*, *RELN*, *ATRX*, *INSRR*, *TP53*, *COL6A3*. *IDH1*, *TP53*, and *ATRX* are extensively studied and been shown to be relevant in gliomas ({% cite Koschmann2016 %}).
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