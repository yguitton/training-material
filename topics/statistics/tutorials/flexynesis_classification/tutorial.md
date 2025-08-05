---
layout: tutorial_hands_on

title: Modeling Breast Cancer Subtypes using Flexynesis
zenodo_link: https://zenodo.org/records/16287482
questions:
- How can we model breast cancer subtypes using transcriptomics and genomic data?
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
answer_histories:
    - label: "usegalaxy.eu"
      history: https://usegalaxy.eu/u/nilchia/h/final-modeling-breast-cancer-subtypes-tabpfn-1
      date: 2025-08-01
---

Flexynesis represents a state-of-the-art deep learning framework specifically designed for multi-modal data integration in biological research ({% cite Uyar2024 %}). What sets Flexynesis apart is its comprehensive suite of deep learning architectures, including supervised and unsupervised VAEs, that can handle various data integration scenarios while providing robust feature selection and hyperparameter optimization.

Here, we use Flexynesis tool suite on a multi-omics dataset of Breast Cancer samples from the METABRIC consortium ({% cite metabric-website %}), one of the landmark breast cancer genomics studies available through cBioPortal ({% cite cbioportal-website %}). This dataset contains comprehensive molecular and clinical data from over 2,000 breast cancer patients, including gene expression profiles, copy number alterations, mutation data, and clinical outcomes. The data was downloaded from Cbioportal and randomly split into train (70% of the samples) and test (30% of the samples) data folders. The data files were processed to follow the same nomenclature.

This training is inspired from the original flexynesis analysis notebook: [brca_subtypes.ipynb](https://github.com/BIMSBbioinfo/flexynesis/blob/main/examples/tutorials/brca_subtypes.ipynb).

> <warning-title>LICENSE</warning-title>
>
> Flexynesis is only available for NON-COMMERCIAL use. Permission is only granted for academic, research, and educational purposes. Before using, be sure to review, agree, and comply with the license.
> For commercial use, please review the flexynesis license on GitHub and contact the [copyright holders](https://github.com/BIMSBbioinfo/flexynesis)
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
>    https://zenodo.org/records/16287482/files/train_cna_brca.tabular
>    https://zenodo.org/records/16287482/files/train_gex_brca.tabular
>    https://zenodo.org/records/16287482/files/train_clin_brca.tabular
>    https://zenodo.org/records/16287482/files/test_cna_brca.tabular
>    https://zenodo.org/records/16287482/files/test_gex_brca.tabular
>    https://zenodo.org/records/16287482/files/test_clin_brca.tabular
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


# Classification task with Flexynesis (1 iteration)

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

Now it's time to train model using Flexynesis:
* We choose whether we want to concatenate the data matrices (early integration) or not (intermediate integration) before running them through the neural networks.
* We want to apply feature selection and keep only top 10% of the features. In the end, we want to keep at least 1000 features per omics layer.
* We apply a variance threshold (for simplicity of demonstration, we want to keep a few most variable features). Setting this to 80, will remove 80% of the features with the lowest variation from each modality.
* We choose which model architecture to use:
  * DirectPred: a fully connected network (standard multilayer perceptron) with supervisor heads (one MLP for each target variable)
* `target_variables`: Column headers in clinical data.
* `hpo_iter`: How many hyperparameter search steps to implement:
  * This example runs 1 hyperparameter search step using DirectPred architecture and a hyperparameter configuration space defined for "DirectPred" with a supervisor head for "CLAUDIN_SUBTYPE" variable. At the end of the parameter optimization, the best model will be selected and returned.

Training a model longer than needed causes the model to overfit, yield worse validation performance, and also it takes a longer time to train the models, considering if we have to run a long hyperparameter optimization routine, not just for 1 step, but say more than 100 steps.

It is possible to set early stopping criteria in flexynesis, which is basically a simple callback that is handled by `Pytorch Lightning`. This is regulated using the `early_stop_patience`. When set to e.g. 10, the training will stop if the validation loss has not been improved in the last 10 epochs.

> <hands-on-title> Flexynesis </hands-on-title>
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
>        - *"Column name in the train clinical data to use for predictions, multiple targets are allowed"*: `Column: 16` (CLAUDIN_SUBTYPE)
>        - In *"Advanced Options"*:
>            - *"Fusion method"*: `intermediate`
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
>
> > <solution-title></solution-title>
> >
> > 1. The results collection contains the following data:
> > * job.embeddings_test (latent space of test data)
> > * job.embeddings_train (latent space of train data)
> > * job.feature_importance.GradientShap (feature importance calculated by GradientShap method)
> > * job.feature_importance.IntegratedGradients (feature importance calculated by IntegratedGradients method)
> > * job.feature_logs.cna
> > * job.feature_logs.gex
> > * job.predicted_labels (Prediction of the created model)
> > * job.stats
> >
> > 2. There are two figures in plot collection:
> > * A PCA plot of the Embeddings colored by known, true subtypes
> > * A PCA plot of the Embeddings colored by predicted subtypes
> >
> {: .solution}
>
{: .question}

## Generate UMAP plot of the embeddings

To generate a UMAP plot, we need to extract the embeddings and predicted table.

> <hands-on-title> Extract embeddings and prediction </hands-on-title>
>
> 1. {% tool [Extract dataset](__EXTRACT_DATASET__) %} with the following parameters:
>    - {% icon param-file %} *"Input List"*: `results` (output of **Flexynesis** {% icon tool %})
>    - *"How should a dataset be selected?"*: `Select by element identifier`
>        - *"Element identifier:"*: `job.embeddings_test`
>
> 2. {% tool [Extract dataset](__EXTRACT_DATASET__) %} with the following parameters:
>    - {% icon param-file %} *"Input List"*: `results` (output of **Flexynesis** {% icon tool %})
>    - *"How should a dataset be selected?"*: `Select by element identifier`
>        - *"Element identifier:"*: `job.predicted_labels`
>
{: .hands_on}

> <question-title></question-title>
>
> 1. What information do we have in predicted labels?
>
> > <solution-title></solution-title>
> >
> > 1. It is a tabular file which contains the probability of each subtype for each sample and a final predicted label based on the probability.
> >
> {: .solution}
>
{: .question}

As you have seen in predicted labels, each sample has a prediction value for each subtype. For UMAP plot we only need the final predicted label.

> <hands-on-title> Remove probabilities (duplicates) </hands-on-title>
>
> 1. {% tool [Sort](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_sort_header_tool/9.5+galaxy2) %} with the following parameters:
>    - *"Sort Query"*: `job.predicted_labels` (output of **Extract dataset** {% icon tool %})
>    - *"Number of header lines"*: `1`
>    - In *"Column selections"*:
>        - {% icon param-repeat %} *"Insert Column selections"*
>            - *"on column"*: `Column: 1`
>            - *"Flavor"*: `Alphabetical sort `
>    - *"Output unique values"*: `Yes`
>
{: .hands_on}

And finally the UMAP plot.

> <hands-on-title> UMAP plot </hands-on-title>
>
> 1. {% tool [Flexynesis plot](toolshed.g2.bx.psu.edu/repos/bgruening/flexynesis_plot/flexynesis_plot/0.2.20+galaxy3) %} with the following parameters:
>    - *"I certify that I am not using this tool for commercial purposes."*: `Yes`
>    - *"Flexynesis plot"*: `Dimensionality reduction`
>        - {% icon param-file %} *"Predicted labels"*: `table` (output of **Sort** {% icon tool %})
>        - {% icon param-file %} *"Embeddings"*: `job.embeddings_test` (output of **Extract dataset** {% icon tool %})
>        - *"Column in the labels file to use for coloring the points in the plot"*: `Column: 5`
>        - *"Transformation method"*: `UMAP`
>
{: .hands_on}

# Longer training

In reality, hyperparameter optimization should run for multiple steps so that the parameter search space is large enough to find a good set. However, for demonstration purposes, we only run it for 5 steps here:
- *"Number of iterations for hyperparameter optimization."*: `5`

> <hands-on-title> Flexynesis </hands-on-title>
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
>        - *"Column name in the train clinical data to use for predictions, multiple targets are allowed"*: `Column: 16` (CLAUDIN_SUBTYPE)
>        - In *"Advanced Options"*:
>            - *"Fusion method"*: `intermediate`
>            - *"Variance threshold (as percentile) to drop low variance features."*: `0.8`
>            - *"Minimum number of features to retain after feature selection."*: `100`
>            - *"Top percentile features (among the features remaining after variance filtering and data cleanup) to retain after feature selection."*: `10.0`
>            - *"Number of iterations for hyperparameter optimization."*: `5`
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

## Generate UMAP plot of the embeddings

To generate a UMAP plot, we need to extract the embeddings and predicted table.

> <hands-on-title> Extract embeddings and prediction </hands-on-title>
>
> 1. {% tool [Extract dataset](__EXTRACT_DATASET__) %} with the following parameters:
>    - {% icon param-file %} *"Input List"*: `results` (output of **Flexynesis** {% icon tool %})
>    - *"How should a dataset be selected?"*: `Select by element identifier`
>        - *"Element identifier:"*: `job.embeddings_test`
>
> 2. {% tool [Extract dataset](__EXTRACT_DATASET__) %} with the following parameters:
>    - {% icon param-file %} *"Input List"*: `results` (output of **Flexynesis** {% icon tool %})
>    - *"How should a dataset be selected?"*: `Select by element identifier`
>        - *"Element identifier:"*: `job.predicted_labels`
>
{: .hands_on}

> <hands-on-title> Remove probabilities (duplicates) </hands-on-title>
>
> 1. {% tool [Sort](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_sort_header_tool/9.5+galaxy2) %} with the following parameters:
>    - *"Sort Query"*: `job.predicted_labels` (output of **Extract dataset** {% icon tool %})
>    - *"Number of header lines"*: `1`
>    - In *"Column selections"*:
>        - {% icon param-repeat %} *"Insert Column selections"*
>            - *"on column"*: `Column: 1`
>            - *"Flavor"*: `Alphabetical sort `
>    - *"Output unique values"*: `Yes`
>
{: .hands_on}

And finally the UMAP plot.

> <hands-on-title> UMAP plot </hands-on-title>
>
> 1. {% tool [Flexynesis plot](toolshed.g2.bx.psu.edu/repos/bgruening/flexynesis_plot/flexynesis_plot/0.2.20+galaxy3) %} with the following parameters:
>    - *"I certify that I am not using this tool for commercial purposes."*: `Yes`
>    - *"Flexynesis plot"*: `Dimensionality reduction`
>        - {% icon param-file %} *"Predicted labels"*: `table` (output of **Sort** {% icon tool %})
>        - {% icon param-file %} *"Embeddings"*: `job.embeddings_test` (output of **Extract dataset** {% icon tool %})
>        - *"Column in the labels file to use for coloring the points in the plot"*: `Column: 5`
>        - *"Transformation method"*: `UMAP`
>
{: .hands_on}

{% include _includes/cyoa-choices.html option1="Let's try TABPFN!" option2="I'll try later!" default="I'll try later!" text="We have another tool for the classification task called **TABPFN** which is a foundation model for tabular data. We can repeat the classification task using TABPFN and compare it with Flexynesis. Please note that TABPFN is slow on CPU and **it will take a lot of time to finish on this dataset**. What do you say? Should we continue with TABPFN?" disambiguation="tool"%}

<div class="Ill-try-later" markdown="1">

# Conclusion

In this tutorial, we demonstrated how Flexynesis can model breast cancer subtypes from multi omics data using a deep generative framework. The tool handles preprocessing, feature selection, and latent space learning automatically, making it efficient and robust.

By training on TCGA BRCA data, we:

  * Visualized meaningful subtype separation in the latent space

  * Identified subtype-specific genes

  * Showed how learned features relate to known clinical labels

Flexynesis provides an accessible way to explore complex omics datasets and uncover biological structure without extensive manual tuning.
</div>

<div class="Lets-try-TABPFN" markdown="1">

Alright, Let's see how TABPFN can predict the subtypes

# Prepare data for TABPFN

Currently, TabPFN supports up to **10,000** samples and **500** features (genes) in a tabular data.
We will filter our data by gene variance and will use top 500 variable genes as input for TABPFN.

The train and test tabular data for TABPFN should be transposed so the samples are in rows and genes in columns, the last column should contain the labels and train and test data should have **same** set of features in **same** order.

Since TABPFN does not support data integration, we should try gene expression and copy number alteration data separately.

## CNA data

First, let's filter the cna data by variance.

> <hands-on-title> Prepare CNA data </hands-on-title>
>
> > <comment-title> Short explanation of steps: </comment-title>
> > Here we will:
> > * Calculate the variance of each gene in train matrix
> > * Add the variance back to the matrix
> > * Sort the matrix by variance in descending order
> > * Filter the matrix by top 500 genes
> > * Sort the matrix by gene name
>    {: .comment}
>
> 1. {% tool [Table Compute](toolshed.g2.bx.psu.edu/repos/iuc/table_compute/table_compute/1.2.4+galaxy2) %} with the following parameters:
>    - *"Input Single or Multiple Tables"*: `Single Table`
>        - {% icon param-file %} *"Table"*: `train_cna_brca.tabular`
>        - *"Type of table operation"*: `Compute expression across rows or columns`
>            - *"Calculate"*: `Variance`
>            - *"For each"*: `Row`
>
> 2. {% tool [Join two Datasets](join1) %} with the following parameters:
>    - {% icon param-file %} *"Join"*: `table` (output of **Table Compute** {% icon tool %})
>    - *"using column"*: `Column: 1`
>    - {% icon param-file %} *"with"*: `train_cna_brca.tabular`
>    - *"and column"*: `Column: 1`
>    - *"Fill empty columns"*: `No`
>    - *"Keep the header lines"*: `Yes`
>
> 3. {% tool [Sort](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_sort_header_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"Sort Query"*: `table` (output of **Join two Datasets** {% icon tool %})
>    - *"Number of header lines"*: `1`
>    - In *"Column selections"*:
>        - {% icon param-repeat %} *"Insert Column selections"*
>            - *"on column"*: `Column: 2`
>            - *"in"*: `Descending order`
>            - *"Flavor"*: `Fast numeric sort (-n) `
>
> 4. {% tool [Select first](Show beginning1) %} with the following parameters:
>    - *"Select first"*: `500`
>    - {% icon param-file %} *"from"*: `table` (output of **Sort** {% icon tool %})
>    - *"Dataset has a header"*: `Yes`
>
> 5. {% tool [Advanced Cut](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_cut_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"File to cut"*: `table` (output of **Select first** {% icon tool %})
>    - *"Operation"*: `Discard`
>    - *"Cut by"*: `fields`
>        - *"Is there a header for the data's columns ?"*: `Yes`
>            - *"List of Fields"*: `Column: 1`, `Column: 2`
>
> 6. {% tool [Sort](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_sort_header_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"Sort Query"*: `table` (output of **Advanced Cut** {% icon tool %})
>    - *"Number of header lines"*: `1`
>    - In *"Column selections"*:
>        - {% icon param-repeat %} *"Insert Column selections"*
>            - *"on column"*: `Column: 1`
>            - *"Flavor"*: `Alphabetical sort `
>
> 7. Rename the output file to `train_cna_brca_500gene.tabular`
>
> > <comment-title> Short explanation of steps: </comment-title>
> > Here we will:
> > * Extract the list of genes from the train matrix
> > * Filter the test data by extracted genes
> > * Sort the matrix by gene name
> > * Transpose both train and test data
>    {: .comment}
>
> 1. {% tool [Advanced Cut](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_cut_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"File to cut"*: `train_cna_brca_500gene.tabular` (output of **Advanced Cut** {% icon tool %})
>    - *"Operation"*: `Keep`
>    - *"Cut by"*: `fields`
>        - *"Is there a header for the data's columns ?"*: `Yes`
>            - *"List of Fields"*: `Column: 1`
>
> 2. {% tool [Join](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_easyjoin_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"1st file"*: `table` (output of **Advanced Cut** {% icon tool %})
>    - *"Column to use from 1st file"*: `Column: 1`
>    - {% icon param-file %} *"2nd File"*: `test_cna_brca.tabular`
>    - *"Column to use from 2nd file"*: `Column: 1`
>    - *"First line is a header line"*: `Yes`
>
> 3. {% tool [Sort](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_sort_header_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"Sort Query"*: `output` (output of **Join** {% icon tool %})
>    - *"Number of header lines"*: `1`
>    - In *"Column selections"*:
>        - {% icon param-repeat %} *"Insert Column selections"*
>            - *"on column"*: `Column: 1`
>            - *"Flavor"*: `Alphabetical sort `
>
> 4. Rename the output file to `test_cna_brca_500gene.tabular`
>
> 5. {% tool [Transpose](toolshed.g2.bx.psu.edu/repos/iuc/datamash_transpose/datamash_transpose/1.9+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Input tabular dataset"*: `train_cna_brca_500gene.tabular` (output of **Sort** {% icon tool %})
>
> 4. Rename the output file to `train_cna_brca_500gene_transposed.tabular`
>
> 6. {% tool [Transpose](toolshed.g2.bx.psu.edu/repos/iuc/datamash_transpose/datamash_transpose/1.9+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Input tabular dataset"*: `test_cna_brca_500gene.tabular` (output of **Sort** {% icon tool %})
>
> 4. Rename the output file to `test_cna_brca_500gene_transposed.tabular`
>
> > <comment-title> Short explanation of steps: </comment-title>
> > Here we will:
> > * Extract `sample_id` and `CLAUDIN_SUBTYPE` from the train and clinical data
> > * Add the subtype to the train and test matrix
> > * And finally remove the `sample_id` from the matrices.
>    {: .comment}
>
> 1. {% tool [Advanced Cut](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_cut_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"File to cut"*: `train_clin_brca.tabular` (Input dataset)
>    - *"Operation"*: `Keep`
>    - *"Cut by"*: `fields`
>        - *"Is there a header for the data's columns ?"*: `Yes`
>            - *"List of Fields"*: `Column: 1`, `Column: 16`
>
> 2. Rename the output to `Train annotation`
>
> 3. {% tool [Advanced Cut](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_cut_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"File to cut"*: `test_clin_brca.tabular` (Input dataset)
>    - *"Operation"*: `Keep`
>    - *"Cut by"*: `fields`
>        - *"Is there a header for the data's columns ?"*: `Yes`
>            - *"List of Fields"*: `Column: 1`, `Column: 16`
>
> 2. Rename the output to `Test annotation`
>
> 3. {% tool [Join](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_easyjoin_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"1st file"*: `train_cna_brca_500gene_transposed.tabular` (output of **Transpose** {% icon tool %})
>    - *"Column to use from 1st file"*: `Column: 1`
>    - {% icon param-file %} *"2nd File"*: `Train annotation` (output of **Advanced Cut** {% icon tool %})
>    - *"Column to use from 2nd file"*: `Column: 1`
>    - *"First line is a header line"*: `Yes`
>
> 2. Rename the output to `Annotated train matrix`
>
> 3. {% tool [Join](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_easyjoin_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"1st file"*: `test_cna_brca_500gene_transposed.tabular` (output of **Transpose** {% icon tool %})
>    - *"Column to use from 1st file"*: `Column: 1`
>    - {% icon param-file %} *"2nd File"*: `Test annotation` (output of **Advanced Cut** {% icon tool %})
>    - *"Column to use from 2nd file"*: `Column: 1`
>    - *"First line is a header line"*: `Yes`
>
> 2. Rename the output to `Annotated test matrix`
>
> 1. {% tool [Advanced Cut](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_cut_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"File to cut"*: `Annotated train matrix` (output of **Join** {% icon tool %})
>    - *"Operation"*: `Discard`
>    - *"Cut by"*: `fields`
>        - *"Is there a header for the data's columns ?"*: `Yes`
>            - *"List of Fields"*: `Column: 1`
>
> 2. Rename the output to `TABPFN ready train data - CNA`
>
> 1. {% tool [Advanced Cut](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_cut_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"File to cut"*: `Annotated test matrix` (output of **Join** {% icon tool %})
>    - *"Operation"*: `Discard`
>    - *"Cut by"*: `fields`
>        - *"Is there a header for the data's columns ?"*: `Yes`
>            - *"List of Fields"*: `Column: 1`
>
> 2. Rename the output to `TABPFN ready test data - CNA`
{: .hands_on}

Now the CNA data is ready for TABPFN. Let's do the same for GEX!

## GEX data

> <hands-on-title> Prepare GEX data </hands-on-title>
>
> > <comment-title> Short explanation of steps: </comment-title>
> > Here we will:
> > * Calculate the variance of each gene in train matrix
> > * Add the variance back to the matrix
> > * Sort the matrix by variance in descending order
> > * Filter the matrix by top 500 genes
> > * Sort the matrix by gene name
>    {: .comment}
>
> 1. {% tool [Table Compute](toolshed.g2.bx.psu.edu/repos/iuc/table_compute/table_compute/1.2.4+galaxy2) %} with the following parameters:
>    - *"Input Single or Multiple Tables"*: `Single Table`
>        - {% icon param-file %} *"Table"*: `train_gex_brca.tabular`
>        - *"Type of table operation"*: `Compute expression across rows or columns`
>            - *"Calculate"*: `Variance`
>            - *"For each"*: `Row`
>
> 2. {% tool [Join two Datasets](join1) %} with the following parameters:
>    - {% icon param-file %} *"Join"*: `table` (output of **Table Compute** {% icon tool %})
>    - *"using column"*: `Column: 1`
>    - {% icon param-file %} *"with"*: `train_gex_brca.tabular`
>    - *"and column"*: `Column: 1`
>    - *"Fill empty columns"*: `No`
>    - *"Keep the header lines"*: `Yes`
>
> 3. {% tool [Sort](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_sort_header_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"Sort Query"*: `table` (output of **Join two Datasets** {% icon tool %})
>    - *"Number of header lines"*: `1`
>    - In *"Column selections"*:
>        - {% icon param-repeat %} *"Insert Column selections"*
>            - *"on column"*: `Column: 2`
>            - *"in"*: `Descending order`
>            - *"Flavor"*: `Fast numeric sort (-n) `
>
> 4. {% tool [Select first](Show beginning1) %} with the following parameters:
>    - *"Select first"*: `500`
>    - {% icon param-file %} *"from"*: `table` (output of **Sort** {% icon tool %})
>    - *"Dataset has a header"*: `Yes`
>
> 5. {% tool [Advanced Cut](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_cut_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"File to cut"*: `table` (output of **Select first** {% icon tool %})
>    - *"Operation"*: `Discard`
>    - *"Cut by"*: `fields`
>        - *"Is there a header for the data's columns ?"*: `Yes`
>            - *"List of Fields"*: `Column: 1`, `Column: 2`
>
> 6. {% tool [Sort](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_sort_header_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"Sort Query"*: `table` (output of **Advanced Cut** {% icon tool %})
>    - *"Number of header lines"*: `1`
>    - In *"Column selections"*:
>        - {% icon param-repeat %} *"Insert Column selections"*
>            - *"on column"*: `Column: 1`
>            - *"Flavor"*: `Alphabetical sort `
>
> 7. Rename the output file to `train_gex_brca_500gene.tabular`
>
> > <comment-title> Short explanation of steps: </comment-title>
> > Here we will:
> > * Extract the list of genes from the train matrix
> > * Filter the test data by extracted genes
> > * Sort the matrix by gene name
> > * Transpose both train and test data
>    {: .comment}
>
> 1. {% tool [Advanced Cut](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_cut_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"File to cut"*: `train_gex_brca_500gene.tabular` (output of **Advanced Cut** {% icon tool %})
>    - *"Operation"*: `Keep`
>    - *"Cut by"*: `fields`
>        - *"Is there a header for the data's columns ?"*: `Yes`
>            - *"List of Fields"*: `Column: 1`
>
> 2. {% tool [Join](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_easyjoin_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"1st file"*: `table` (output of **Advanced Cut** {% icon tool %})
>    - *"Column to use from 1st file"*: `Column: 1`
>    - {% icon param-file %} *"2nd File"*: `test_gex_brca.tabular`
>    - *"Column to use from 2nd file"*: `Column: 1`
>    - *"First line is a header line"*: `Yes`
>
> 3. {% tool [Sort](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_sort_header_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"Sort Query"*: `output` (output of **Join** {% icon tool %})
>    - *"Number of header lines"*: `1`
>    - In *"Column selections"*:
>        - {% icon param-repeat %} *"Insert Column selections"*
>            - *"on column"*: `Column: 1`
>            - *"Flavor"*: `Alphabetical sort `
>
> 4. Rename the output file to `test_gex_brca_500gene.tabular`
>
> 5. {% tool [Transpose](toolshed.g2.bx.psu.edu/repos/iuc/datamash_transpose/datamash_transpose/1.9+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Input tabular dataset"*: `train_gex_brca_500gene.tabular` (output of **Sort** {% icon tool %})
>
> 4. Rename the output file to `train_gex_brca_500gene_transposed.tabular`
>
> 6. {% tool [Transpose](toolshed.g2.bx.psu.edu/repos/iuc/datamash_transpose/datamash_transpose/1.9+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Input tabular dataset"*: `test_gex_brca_500gene.tabular` (output of **Sort** {% icon tool %})
>
> 4. Rename the output file to `test_gex_brca_500gene_transposed.tabular`
>
> > <comment-title> Short explanation of steps: </comment-title>
> > Here we will:
> > * Extract `sample_id` and `CLAUDIN_SUBTYPE` from the train and clinical data
> > * Add the subtype to the train and test matrix
> > * And finally remove the `sample_id` from the matrices.
>    {: .comment}
>
> 1. {% tool [Advanced Cut](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_cut_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"File to cut"*: `train_clin_brca.tabular` (Input dataset)
>    - *"Operation"*: `Keep`
>    - *"Cut by"*: `fields`
>        - *"Is there a header for the data's columns ?"*: `Yes`
>            - *"List of Fields"*: `Column: 1`, `Column: 16`
>
> 2. Rename the output to `Train annotation`
>
> 3. {% tool [Advanced Cut](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_cut_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"File to cut"*: `test_clin_brca.tabular` (Input dataset)
>    - *"Operation"*: `Keep`
>    - *"Cut by"*: `fields`
>        - *"Is there a header for the data's columns ?"*: `Yes`
>            - *"List of Fields"*: `Column: 1`, `Column: 16`
>
> 2. Rename the output to `Test annotation`
>
> 3. {% tool [Join](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_easyjoin_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"1st file"*: `train_gex_brca_500gene_transposed.tabular` (output of **Transpose** {% icon tool %})
>    - *"Column to use from 1st file"*: `Column: 1`
>    - {% icon param-file %} *"2nd File"*: `Train annotation` (output of **Advanced Cut** {% icon tool %})
>    - *"Column to use from 2nd file"*: `Column: 1`
>    - *"First line is a header line"*: `Yes`
>
> 2. Rename the output to `Annotated train matrix`
>
> 3. {% tool [Join](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_easyjoin_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"1st file"*: `test_gex_brca_500gene_transposed.tabular` (output of **Transpose** {% icon tool %})
>    - *"Column to use from 1st file"*: `Column: 1`
>    - {% icon param-file %} *"2nd File"*: `Test annotation` (output of **Advanced Cut** {% icon tool %})
>    - *"Column to use from 2nd file"*: `Column: 1`
>    - *"First line is a header line"*: `Yes`
>
> 2. Rename the output to `Annotated test matrix`
>
> 1. {% tool [Advanced Cut](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_cut_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"File to cut"*: `Annotated train matrix` (output of **Join** {% icon tool %})
>    - *"Operation"*: `Discard`
>    - *"Cut by"*: `fields`
>        - *"Is there a header for the data's columns ?"*: `Yes`
>            - *"List of Fields"*: `Column: 1`
>
> 2. Rename the output to `TABPFN ready train data - GEX`
>
> 1. {% tool [Advanced Cut](toolshed.g2.bx.psu.edu/repos/bgruening/text_processing/tp_cut_tool/9.5+galaxy2) %} with the following parameters:
>    - {% icon param-file %} *"File to cut"*: `Annotated test matrix` (output of **Join** {% icon tool %})
>    - *"Operation"*: `Discard`
>    - *"Cut by"*: `fields`
>        - *"Is there a header for the data's columns ?"*: `Yes`
>            - *"List of Fields"*: `Column: 1`
>
> 2. Rename the output to `TABPFN ready test data - GEX`
{: .hands_on}

Now it is time to run TABPFN for CNA and GEX data.

# TABPFN

> <warning-title>High computation time</warning-title>
>
> TABPFN takes a lot of time to do the classification task on CPU (With our data it takes about 7 hours)
> You can instead import the output (data 56-59) from this [archived history](https://usegalaxy.eu/u/nilchia/h/final-modeling-breast-cancer-subtypes-tabpfn-1).
{: .warning}

> <hands-on-title> TABPFN on CNA </hands-on-title>
>
> 1. {% tool [Tabular data prediction using TabPFN](toolshed.g2.bx.psu.edu/repos/bgruening/tabpfn/tabpfn/2.0.9+galaxy0) %} with the following parameters:
>    - *"Select a machine learning task"*: `Classification`
>    - {% icon param-file %} *"Train data"*: `TABPFN ready train data - CNA` (output of **Advanced Cut** {% icon tool %})
>    - {% icon param-file %} *"test data"*: `TABPFN ready test data - CNA` (output of **Advanced Cut** {% icon tool %})
>    - *"Does test data contain labels?"*: `Yes`
>
{: .hands_on}

> <hands-on-title> TABPFN on GEX </hands-on-title>
>
> 1. {% tool [Tabular data prediction using TabPFN](toolshed.g2.bx.psu.edu/repos/bgruening/tabpfn/tabpfn/2.0.9+galaxy0) %} with the following parameters:
>    - *"Select a machine learning task"*: `Classification`
>    - {% icon param-file %} *"Train data"*: `TABPFN ready train data - GEX` (output of **Advanced Cut** {% icon tool %})
>    - {% icon param-file %} *"test data"*: `TABPFN ready test data - GEX` (output of **Advanced Cut** {% icon tool %})
>    - *"Does test data contain labels?"*: `Yes`
>
{: .hands_on}

> <question-title></question-title>
>
> 1. Compare the PR-curve plots of both flexynesis and TABPFN predictions, which one is more accurate?
>
> > <solution-title></solution-title>
> >
> > 1. Looking and the plots, It is clear that Flexynesis has overall better prediction compared to TABPFN
> >![Precision-Recall curve plot of Flexynesis](../../images/flexynesis_classification/pr_curve-flexynesis.jpeg "Precision-Recall curve plot of Flexynesis")
> >![Precision-Recall curve plot of TABPFN on CNA](../../images/flexynesis_classification/pr_curve-tabpfn_cna.png "Precision-Recall curve plot of TABPFN on CNA")
> >![Precision-Recall curve plot of TABPFN on GEX](../../images/flexynesis_classification/pr_curve-tabpfn_gex.png "Precision-Recall curve plot of TABPFN on GEX")
> {: .solution}
>
{: .question}

# Conclusion

In this tutorial, we demonstrated how Flexynesis can model breast cancer subtypes from multi omics data using a deep generative framework. The tool handles preprocessing, feature selection, and latent space learning automatically, making it efficient and robust.

By training on TCGA BRCA data, we:

  * Visualized meaningful subtype separation in the latent space

  * Identified subtype-specific genes

  * Showed how learned features relate to known clinical labels

Flexynesis provides a fast and accessible way to explore complex omics datasets and uncover biological structure without extensive manual tuning.

</div>