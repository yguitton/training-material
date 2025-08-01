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

# Conclusion

In this tutorial, we demonstrated how Flexynesis can model breast cancer subtypes from multi omics data using a deep generative framework. The tool handles preprocessing, feature selection, and latent space learning automatically, making it efficient and robust.

By training on TCGA BRCA data, we:

  * Visualized meaningful subtype separation in the latent space

  * Identified subtype-specific genes

  * Showed how learned features relate to known clinical labels

Flexynesis provides an accessible way to explore complex omics datasets and uncover biological structure without extensive manual tuning.