---
layout: tutorial_hands_on
title: "Regulations/standards for AI using DOME"
level: Intermediate
draft: true
questions:
- to do
objectives:
- to do
time_estimation: 3H
key_points:
- To be added
contributions:
  authorship:
  - fpsom
  - sfragkoul
tags:
- elixir
- ai-ml
priority: 6
notebook:
  language: python
  pyolite: true
---

<!--- From Docs: Introduction -->
## The need for standardization

With the significant drop in the cost of many high-throughput technologies, vast amounts of biological data are being generated and made available to researchers. 
Machine learning (ML) has emerged as a powerful tool for analyzing data related to cellular processes, genomics, proteomics, post-translational modifications, metabolism, and drug discovery, offering the potential for transformative medical advancements. 
This trend is evident in the growing number of ML publications, showcasing a wide array of modeling techniques in biology. 
However, although ML methods should ideally be experimentally validated, this occurs in only a small portion of the studies. 
We believe the time is right for the ML community to establish standards for reporting ML-based analyses to facilitate critical evaluation and enhance reproducibility.[@DOME]


<figure>
<img src="../../assets/images/ML_Biology.png" width="600" alt="Bar plots showing the trend of usage of ML in Biology."/>
<figcaption> <p style='text-align: justify;'>The number of ML publications per year is based on Web of Science from 1996 onwards using the topic category for “machine learning” in combination with each of the following terms: “biolog*”, “medicine”, “genom*”, “prote*”, “cell*”, “post translational”, “metabolic” and “clinical”.</p></figcaption>
</figure>


Guidelines or recommendations on the proper construction of machine learning (ML) algorithms can help ensure accurate results and predictions. 
In biomedical research, various communities have established standard guidelines and best practices for managing scientific data and ensuring the reproducibility of computational tools. 
Similarly, within the ML community, there is a growing need for a unified set of recommendations that address data handling, optimization techniques, model development, and evaluation protocols comprehensively.

A recent commentary emphasized the need for standards in ML,suggesting that introducing submission checklists could be a first step toward improving publication practices. 
In response,  a community-driven consensus list of minimal requirements was proposed, framed as questions for ML implementers. By adhering to these guidelines, the quality and reliability of reported methods can be more accurately assessed. 
Our focus is on data, optimization, model, and evaluation (DOME), as these four components encompass the core aspects of most ML implementations. These recommendations are primarily aimed at supervised learning in biological applications where direct experimental validation is absent, as this is the most commonly used ML approach. 
We do not address the use of ML in clinical settings, and it remains to be seen whether the DOME recommendations can be applied to other areas of ML, such as unsupervised, semi-supervised, or reinforcement learning.

## Development of the recommendations


| __Broad topic__     | __Be on the lookout for__       | 	__Consequences__     | __Recommendation(s)__		|
|-------    |-------    |---------  | --------- |
| Data     		| • Inadequate data size & quality <br> • Inappropriate partitioning, dependence between train and test data <br> • Class imbalance <br> • No access to data <br>   | • Data not representative of domain application <br> • Unreliable or biased performance evaluation <br> • Cannot check data credibility   | __• Use independent optimization (training) and evaluation (testing) sets__. This is especially important for meta algorithms, where independence of multiple training sets must be shown to be independent of the evaluation (testing) sets. <br> __• Release data, preferably using appropriate long-term repositories, and include exact splits.__  <br> • Offer sufficient evidence of data size & distribution being representative of the domain.|
| Optimization  | • Overfitting, underfitting, and illegal parameter tuning <br> • Imprecise parameters and protocols given <br>  | • Reported performance is too optimistic or too pessimistic <br> • The model models noise or misses relevant relationships <br> • Results are not reproducible | __• Clarify that evaluation sets were not used for feature selection.__ <br> __• Report indicators on training and testing data that can aid in assessing the possibility of under- or overfitting; for example, train vs. test error.__ <br> __• Release definitions of all algorithmic hyperparameters, regularization protocols, parameters and optimization protocol.__ <br> • For neural networks, release definitions of training and learning curves.  <br>  • Include explicit model validation techniques like *N*-fold cross-validation. |
| Model     	| • Unclear if black box or interpretable model <br> • No access to resulting source code, trained models & data <br> • Execution time impractical | • An interpretable model shows no explainable behavior <br> • Cannot cross compare methods & reproducibility, or check data credibility <br> • Model takes too much time to produce results | __• Describe the choice of black box or interpretable model. If interpretable, show examples of interpretable output.__ <br> • Release documented source code + models + software containers. <br> • Report execution time averaged across repeats. If computationally tough, compare to similar methods. |
| Evaluation    | • Performance measures inadequate <br> • No comparisons to baselines or other methods <br> • Highly variable performance | • Biased performance measures reported <br> • The method is falsely claimed as state-of-the-art <br> • Unpredictable performance in production | __• Compare with public methods & simple models (baselines).__ <br> __• Adopt community-validated measures and benchmark datasets for evaluation.__ <br> • Compare related methods and alternatives on the same dataset.  <br> • Evaluate performance on a final independent held-out set.  <br> __• Use confidence intervals/error intervals and statistical tests to gauge robustness.__ |


The recommendations mentioned above were initially developed by the [ELIXIR Machine Learning Focus Group](https://elixir-europe.org/focus-groups/machine-learning) in response to a published Comment advocating for the establishment of standards in ML for biology. 
This focus group, comprising over 50 experts in the field of ML, held meetings to collaboratively develop and refine the recommendations through broad consensus.

In the following chapters the publication from [@MobiDB] is going to be used as an example.



<!--- From Docs: Chapter 01 -->

<p style='text-align: justify;'>
ML models analyze experimental biological data by identifying patterns, which can then be used to generate biological insights from similar, previously unseen data. 
The ability of a model to maintain its performance on new data is referred to as its generalization power. 
Achieving strong generalization is a key challenge in developing ML models; without it, trained models cannot be effectively reused. 
Properly preprocessing data and using it in an informed way are essential steps to ensure good generalization.
</p>



??? Note "Further Reading"
	
    State-of-the-art ML models are often capable of memorizing all variations within the training data. As a result, when evaluated on data from the training set, they may give the false impression of excelling at the given task. However, their performance tends to diminish when tested on independent data (called the test or validation set), revealing a lower generalization power. To address this issue, the original dataset should be randomly split into non-overlapping parts. The simplest method involves creating separate training and test sets (with a possible third validation set). Alternatively, more robust techniques like cross-validation or bootstrapping, which repeatedly create different training/testing splits from the available data, are often preferred.
	
	Handling overlap between training and test data can be especially challenging in biology. For instance, in predicting entire gene or protein sequences, ensuring data independence might require reducing homologs in the dataset. In modeling enhancer–promoter contacts, a different criterion may be needed, such as ensuring that no endpoint is shared between training and test sets. Similarly, modeling protein domains may require splitting multidomain sequences into their individual domains before applying homology reduction. Each biological field has its own methods for managing overlapping data, making it crucial to consult prior literature when developing an approach.
	
	Providing details on the size of the dataset and the distribution of data types helps demonstrate whether the data is well-represented across different sets. Simple visualizations, such as plots or tables, showing the number of classes (for classification), a histogram of binned values (for regression), and the various types of biological molecules included in the data, are essential for understanding each set. Additionally, for classification tasks, methods that account for imbalanced classes should be used if the class frequencies suggest a significant imbalance.
	
	It’s also important to note that models trained on one dataset may not perform well on closely related, but distinct, datasets—a phenomenon known as "covariance shift." This issue has been observed in several recent studies, such as those predicting disease risk from exome sequencing data. While covariance shift remains an open problem, potential solutions have been proposed, particularly in the field of transfer learning. Furthermore, building ML models that generalize well on small training datasets often requires specialized models and algorithms.
	
	Finally, making experimental data publicly available is crucial. Open access to datasets, including precise data splits, enhances the reproducibility of research and improves the overall quality of ML publications. If public repositories are not available, authors should be encouraged to use platforms like ELIXIR deposition databases or Zenodo to ensure long-term data accessibility.[@DOME]
	

## 1.1 Provenance 

<p style='text-align: justify;'>
Provenance of data refers to the origin, history, and lineage of data—essentially, tracking where the data came from, how it has been processed, and how it has moved through various systems. It’s like a detailed record that traces the data's life cycle from creation to its current state. Understanding data provenance helps ensure transparency, trustworthiness, and reliability in data usage.
</p>

<ins>Key Questions</ins>

- What is the __source__ of the data (database, publication, direct experiment)? 
- If data are in __classes__, how many data points are available in each class—for example, total for the positive (*Npos*) and negative (*Nneg*) cases? 
- If __regression__, how many real value points are there? 
- Has the dataset been __previously used__ by other papers and/or is it recognized by the community?

!!! example "From Example Publication"
	
	Protein Data Bank (PDB). X-ray structures missing residues. <br>  *Npos* = 339,603 residues. <br>  *Nneg* = 6,168,717 residues. <br> Previously used in (Walsh et al., Bioinformatics 2015) as an independent benchmark set.


## 1.2 Dataset Splits

<p style='text-align: justify;'>
Dataset splits refer to the process of dividing a dataset into distinct subsets for different purposes, mainly in machine learning or data science tasks. The most common splits are:
</p>

- Training Set: This is the largest subset, used to train the machine learning model. The model "learns" from this data by adjusting its internal parameters to minimize prediction errors.

- Validation Set: A separate subset used to fine-tune the model's hyperparameters. The model doesn't learn directly from this data, but it helps monitor the model's performance and avoid overfitting, which is when a model becomes too tailored to the training data and doesn't generalize well.

- Test Set: This is the final subset, used to evaluate the model's performance. The test set remains unseen by the model until after training and validation are complete, providing an unbiased estimate of how well the model generalizes to new, unseen data.


<p style='text-align: justify;'>
In addition to these, there are some variations in dataset splitting strategies:
</p>


- Holdout Split: A simple division where a fixed percentage of data is reserved for testing (e.g., 80% training, 20% test).

- Cross-validation: In this technique, the dataset is split multiple times into training and validation sets, ensuring each data point is used for validation at least once (e.g., 5-fold cross-validation). This provides a more robust evaluation of the model’s performance.


<ins>Key Questions</ins>

- How __many data points__ are in the training and test sets? 
- Was a __separate validation__ set used, and if yes, how large was it? 
- Are the __distributions__ of data types (*N<sub>pos</sub>* and *N<sub>neg</sub>*) in the training and test sets different? Are the distributions of data types in both training and test sets plotted?

!!! example "From Example Publication"
	Protein Data Bank (PDB). X-ray structures missing residues. <br>  *Npos* = 339,603 residues. <br>  *Nneg* = 6,168,717 residues. <br> Previously used in (Walsh et al., Bioinformatics 2015) as an independent benchmark set.


## 1.3 Redundancy between data splits

<p style='text-align: justify;'>
 Redundancy between data splits occurs when the same data points are present in more than one of the training, validation, or test sets. This is undesirable because it can distort model evaluation and lead to overoptimistic performance metrics (e.g. eliminating data points more similar than X%). 
This may effect the mfodel by introcuding an overfitting risk, unreliable performance metrics and/or lack of generalization.
</p>

<ins>Key Questions</ins>

 - How were the sets __split__? 
 - Are the training and test sets __independent__? 
 - How was this __enforced__ (for example, redundancy reduction to less than X% pairwise identity)? 
 - How does the distribution compare to __previously published__ ML datasets?

!!! example "From Example Publication"
	Not applicable.  

## 1.4 Availability of data

<p style='text-align: justify;'>
Availability of data refers to the accessibility and readiness of data for use in various applications, such as analysis, machine learning, decision-making, or reporting. It ensures that data can be retrieved and utilized when needed by users or systems.
</p>


<ins>Key Questions</ins>

- Are the data, including the data splits used, __released__ in a public forum? 
- If yes, __where__ (for example, supporting material, URL) and __how__ (license)?

!!! example "From Example Publication"
	Yes, URL: http://protein.bio.unipd.it/mobidblite/. <br> Free use license.

<br> 

<!--- From Docs: Chapter 02 -->
<p style='text-align: justify;'>
Optimization, or model training, refers to the process of adjusting the values that make up the model (including both parameters and hyperparameters) to enhance the model's performance in solving a given problem. In this section, we will focus on challenges that arise from selecting suboptimal optimization strategies.
</p>

??? Note "Further Reading"
	Optimization, or training, involves adjusting the values that define a model (such as parameters and hyperparameters), as well as preprocessing steps, to enhance the model’s ability to solve a given problem. Choosing an inappropriate optimization strategy can lead to issues like overfitting or underfitting.
	
	Overfitting occurs when a model performs exceptionally well on training data but fails on unseen data, making it ineffective in real-world scenarios. Underfitting, on the other hand, happens when overly simplistic models, capable of capturing only basic relationships between features, are applied to more complex data.
	
	Feature selection algorithms can help reduce the risk of overfitting, but they come with their own set of guidelines. A key recommendation is to avoid using non-training data for feature selection and preprocessing. This is especially problematic for meta-predictors, as it can lead to an overestimation of the model’s performance.
	
	Finally, making files that detail the exact optimization protocol, including parameters and hyperparameters, publicly available is crucial. A lack of proper documentation and limited access to these records can hinder the understanding and evaluation of the model’s overall performance.[@DOME]


## 2.1 Algorithm

<p style='text-align: justify;'>
Since algorithms take input data and produce output, typically solving a particular problem or achieving a specific objective, it is essential to know which one is implemented in a study. In this way we can have better insights for the results of learning patterns, relationships, or rules that can then be applied to new, unseen data.
Regarding ML class there are three major categories:
</p>

- Supervised (i.e. Linear Regression, Logistic Regression, Decision Trees, Support Vector Machines (SVM) and others), 
- Unsupervised Learning (i.e. K-Means Clustering, Principal Component Analysis (PCA) and Hierarchical Clustering and others),  
- Reinforcement Learning (i.e. Q-Learning, Deep Q-Networks (DQN) and others). 


<ins>Key Questions</ins>

- __What__ is the ML algorithm class used? 
- Is the ML algorithm __new__? 
- If yes, why was it __chosen__ over better known alternatives?

!!! example "From Example Publication"
	Majority-based consensus classification based on 8 primary ML methods and post-processing.


## 2.2 Meta-predictions

<p style='text-align: justify;'>
Meta-predictions refer to predictions made by models that aggregate or utilize the outputs (predictions) of other models. Essentially, meta-prediction systems combine predictions from multiple models to produce a more robust or accurate final prediction. Meta-predictions are often used in ensemble learning techniques, where the goal is to leverage the strengths of several models to enhance overall performance.
</p>


<ins>Key Questions</ins>

- Does the model use data from __other__ ML algorithms as input? 
- If yes, which ones? 
- Is it clear that training data of initial predictors and meta-predictor are __independent__ of test data for the meta-predictor?

!!! example "From Example Publication"
	Yes, predictor output is a binary prediction computed from the consensus of other methods; Independence of training sets of other methods with test set of meta-predictor was not tested since datasets from other methods were not available.


## 2.3 Data encoding

<p style='text-align: justify;'>
Data encoding is the process of transforming data from one format or structure into another, often to make it easier for ML models or computational systems to process. 
In ML, data often needs to be encoded to ensure that it can be effectively interpreted by algorithms, especially for algorithms that require numerical input (e.g., neural networks, SVMs).
</p>

<ins>Key Questions</ins>

- How were the data __encoded__ and __preprocessed__ for the ML algorithm?

!!! example "From Example Publication"
	Label-wise average of 8 binary predictions.

## 2.4 Parameters

<p style='text-align: justify;'>
Model parameters are the internal configurations or variables that a model learns from the training data. 
These parameters determine how the model makes predictions and how well it fits the training data. 
The values of these parameters are adjusted during the training process through algorithms like gradient descent or optimization procedures. 
</p>

<ins>Key Questions</ins>

- How many __parameters__ (*p*) are used in the model? 
- How were *p* selected?

!!! example "From Example Publication"
	p = 3 (Consensus score threshold, expansion-erosion window, length threshold). <br> No optimization.

## 2.5 Features

<p style='text-align: justify;'>
In the context of ML, features refer to the individual measurable properties or characteristics of the data being used for training a model. 
They play a crucial role in determining the performance of ML models, as they provide the information that the model needs to make predictions or classifications.
Feature Engineering is the process of creating, modifying, or selecting the most relevant features from the raw data to improve model performance by reducing model complexity, improving training time and avoiding overfitting. 
</p>

<ins>Key Questions</ins>

- How many __features__ (*f*) are used as input? 
- Was __feature selection__ performed? 
- If yes, was it performed using the __training set only__?

!!! example "From Example Publication"
	Not applicable.

## 2.6 Fitting

<p style='text-align: justify;'>
Fitting refers to the process of training a ML model on a dataset by adjusting its parameters to minimize prediction error. 
The goal is to find a balance between underfitting and overfitting, ensuring that the model captures the underlying patterns in the data while still generalizing well to unseen data. 
Proper evaluation, regularization, and tuning of the model during the fitting process are crucial to achieving a good fit.
</p>

<ins>Key Questions</ins>

- Is *p* much larger than the number of training points and/or is *f* large (for example, in classification is *p >> (N<sub>pos</sub> + N<sub>neg</sub>)* and/or *f > 100*)? 
- If yes, how was __overfitting__ ruled out? 
- Conversely, if the number of training points is much larger than *p* and/or *f* is small (for example, *(N<sub>pos</sub> + N<sub>neg</sub>) >> p*  and/or *f < 5*), how was __underfitting__ ruled out?

!!! example "From Example Publication"
	Single input ML methods are used with default parameters. <br> Optimization is a simple majority.

## 2.7 Regularization

<p style='text-align: justify;'>
Regularization is a technique used to prevent overfitting by adding a penalty to the loss function, which discourages the model from becoming too complex. Common regularization techniques include:
</p>

- L1 Regularization (Lasso): Adds a penalty proportional to the absolute value of the coefficients. It encourages sparsity, setting some coefficients to zero.
- L2 Regularization (Ridge): Adds a penalty proportional to the square of the coefficients, discouraging large coefficients and thus reducing model complexity.
- Dropout (in neural networks): Randomly drops a percentage of neurons during training, which helps prevent overfitting by forcing the network to generalize.


<ins>Key Questions</ins>

- Were any __overfitting prevention techniques__ used (for example, early stopping using a validation set)?

- If yes, __which__ ones?

!!! example "From Example Publication"
	No. 


## 2.8 Availability of configuration

<p style='text-align: justify;'>

Availability of configuration refers to the accessibility and transparency of the settings, parameters, and options that can be adjusted or customized in a ML model or system. 
These configurations control how the model is trained, how it makes predictions, and how it operates in different environments. 
Ensuring that the configuration is available, flexible, and easy to modify is important for reproducibility, fine-tuning, and deployment of models.
</p>

<ins>Key Questions</ins>

- Are the hyperparameter configurations, optimization schedule, model files and optimization parameters __reported__? 
- If yes, __where__ (for example, URL) and __how__ (license)?

!!! example "From Example Publication"
	Not applicable.

<br> 

<!--- From Docs: Chapter 03 -->
<p style='text-align: justify;'>
Good overall performance and the model's ability to generalize well to unseen data are crucial factors that significantly impact the applicability of any proposed ML research. However, several other important aspects related to ML models must also be considered.
</p>

??? Note "Further Reading"
	Equally important aspects of ML models include their interpretability and reproducibility. Interpretable models can identify causal relationships in the data and provide logical explanations for their predictions, which is especially valuable in fields like drug design and diagnostics. In contrast, black box models, while often accurate, may not offer understandable insights into the reasons behind their predictions. Both types of models are discussed in more detail elsewhere, and choosing between them involves weighing their respective benefits. The key recommendation is to clearly state whether the model is a black box or interpretable, and if it is interpretable, to provide clear examples of its outputs.
	
	Reproducibility is crucial for ensuring that research outcomes can be effectively utilized and validated by the broader community. Challenges with model reproducibility go beyond merely documenting parameters, hyperparameters, and optimization protocols. Limited access to essential model components (such as source code, model files, parameter configurations, and executables) and high computational demands for running trained models on new data can severely restrict or even prevent reproducibility.[@DOME]


## 3.1 Interpretability

<p style='text-align: justify;'>
Model interpretability refers to the extent to which a human can understand the decisions and predictions made by a ML model. 
Interpretability is crucial for building trust in model outcomes, especially in high-stakes domains such as healthcare and finance, where understanding the rationale behind a model's predictions can have significant implications.
For example neural networks are often criticized for being "black boxes," as their internal workings (like hidden layers) are less transparent, making them more difficult to trust.
There are generally two types of interpretability:
</p>

- <p style='text-align: justify;'> Global Interpretability refers to the ability to understand the overall behavior of the model across all predictions. It involves explaining how the model works as a whole and what features are important in determining predictions. </p>

- <p style='text-align: justify;'> Local interpretability focuses on understanding individual predictions made by the model. It aims to explain why a specific input led to a particular output. </p>

<ins>Key Questions</ins>

- Is the model __black box__ or __interpretable__? 
- If the model is interpretable, can you give clear __examples__ of this?

!!! example "From Example Publication"
	Transparent, in so far as meta-prediction is concerned. Consensus and post processing over other methods predictions (which are mostly black boxes). No attempt was made to make the meta-prediction a black box.


## 3.2 Output

<p style='text-align: justify;'>
The output of a machine learning model refers to the predictions or classifications made by the model after processing input data. 
Depending on the type of model and the nature of the problem, the output can vary widely. 
Here’s a breakdown of some different types of outputs: 
</p>

- <p style='text-align: justify;'> __Regression__ includes continuous values that estimates a quantity based on the input features </p>

- <p style='text-align: justify;'> In __classification__ tasks the output is a category or class label that indicates which class the input belongs to. </p>

- <p style='text-align: justify;'> In __multi-class classification__ the model predicts one class from multiple possible classes. </p>

- <p style='text-align: justify;'> __Multi-label classification__ includes the assignment of multiple classes to a single input.</p>

<ins>Key Questions</ins>

- Is the model __classification__ or __regression__?

!!! example "From Example Publication"
	Classification, i.e. residues thought to be disordered.

## 3.3 Execution time

<p style='text-align: justify;'>
Execution time in the context of ML refers to the duration it takes for a model to perform a specific task, such as training, predicting, or evaluating performance. 
Understanding and measuring execution time is crucial for various reasons, including optimizing model performance, resource management, and user experience. 
</p>

CPU time of single representative execution on standard hardware (e.g. seconds on desktop PC).

<ins>Key Questions</ins>

-  How much __time__ does a single representative prediction require on a standard machine (for example, seconds on a desktop PC or high-performance computing cluster)?

!!! example "From Example Publication"
	ca. 1 second per representative on a desktop PC.

## 3.4 Availability of software

<p style='text-align: justify;'>
Availability of software refers to the accessibility, reliability, and usability of various software tools and libraries that facilitate the development, training, deployment, and evaluation of ML models. 
This includes both open-source and proprietary software, and it is critical for researchers and practitioners to have the right tools at their disposal to effectively work on tasks.
</p>

<ins>Key Questions</ins>

- Is the __source code__ released? 
- Is a __method to run__ the algorithm (executable, web server, virtual machine or container instance) released? 
- If yes, __where__ (for example github, zenodo or other repository URL) and __how__ (for example MIT license)?

!!! example "From Example Publication"
	Yes, URL: http://protein.bio.unipd.it/mobidblite/. <br>  Bespoke license free for academic use

<br> 

<!--- From Docs: Chapter 04 -->
<p style='text-align: justify;'>
In implementing a robust and trustworthy ML method, providing a comprehensive data description, adhering to a correct optimization protocol, and ensuring that the model is clearly defined and openly accessible are critical first steps. Equally important is employing a valid assessment methodology to evaluate the final model.
</p>

??? Note "Further Reading"
	In biological research, there are two main types of evaluation scenarios for ML models: 
	
	1. __Experimental Validation:__ This involves validating the predictions made by the ML model through laboratory experiments. Although highly desirable, this approach is often beyond the scope of many ML studies.
	
	2. __Computational Assessment:__ This involves evaluating the model's performance using established metrics. This section focuses on computational assessment and highlights a few potential risks.
	
	When it comes to performance metrics, which are quantifiable indicators of a model's ability to address a specific task, there are numerous metrics available for various ML classification and regression problems. The wide range of options, along with the domain-specific knowledge needed to choose the right metrics, can result in the selection of inappropriate performance measures. It is advisable to use metrics recommended by critical assessment communities relevant to biological ML models, such as the Critical Assessment of Protein Function Annotation (CAFA) and the Critical Assessment of Genome Interpretation (CAGI).
	
	Once appropriate performance metrics are selected, methods published in the same biological domain should be compared using suitable statistical tests (e.g., Student’s t-test) and confidence intervals. Additionally, to avoid releasing ML methods that seem advanced but do not outperform simpler algorithms, it is important to compare these methods against baseline models and demonstrate their statistical superiority (e.g., comparing shallow versus deep neural networks).[@DOME]




## 4.1 Evaluation method

<p style='text-align: justify;'>
Evaluation of a ML model is the process of assessing its performance and effectiveness in making predictions or classifications based on new, unseen data. 
Proper evaluation is crucial to ensure that the model generalizes well and performs as expected in real-world applications.
</p>

<ins>Key Questions</ins>

- How was the method __evaluated__ (for example cross-validation, independent dataset, novel experiments)?

!!! example "From Example Publication"
	Independent dataset

## 4.2 Performance measures

<p style='text-align: justify;'>
The choice of evaluation metrics depends on the type of problem (regression or classification) and the specific goals of the analysis.
</p>

| Regression Metrics   | Classification Metrics	|
|-------|---------|
| Mean Absolute Error (MAE)  | Accuracy|
| Mean Squared Error (MSE)|  Precision |
| Root Mean Squared Error (RMSE)| Recall (Sensitivity)  |
| R-squared (R<sup>2</sup>) |  F1 Score |


<ins>Key Questions</ins>

- Which __performance metrics__ are reported (Accuracy, sensitivity, specificity, etc.)? 
- Is this set __representative__ (for example, compared to the literature)?

!!! example "From Example Publication"
	Balanced Accuracy, Precision, Sensitivity, Specificity, F1, MCC.

## 4.3 Comparison

<p style='text-align: justify;'>
Comparison typically refers to the evaluation of different models, algorithms, or configurations to identify which one performs best for a specific task. 
This process is essential for selecting the most suitable approach for a given problem, optimizing performance, and understanding the strengths and weaknesses of various methods. 
</p>

<ins>Key Questions</ins>

- Was a comparison to __publicly available__ methods performed on benchmark datasets? 
- Was a comparison to __simpler baselines__ performed?

!!! example "From Example Publication"
	DisEmbl-465, DisEmbl-HL, ESpritz Disprot, ESpritz NMR, ESpritz Xray, Globplot, IUPred long, IUPred short, VSL2b. Chosen methods are the methods from which the meta prediction is obtained.

## 4.4 Confidence

<p style='text-align: justify;'>
Confidence in the context of ML refers to the measure of certainty or belief that a model's prediction is accurate. 
It quantifies the model's certainty regarding its output, which is particularly important in classification tasks, where decisions need to be made based on predicted class probabilities.
This can be supported with medthods such as confidence intervals and statistical significance.
</p>

<ins>Key Questions</ins>

- Do the performance metrics have __confidence intervals__? 
- Are the results __statistically significant__ to claim that the method is superior to others and baselines?

!!! example "From Example Publication"
	Not calculated.

## 4.5 Availability of evaluation

<p style='text-align: justify;'>
Availability of evaluation in ML refers to the accessibility and readiness of tools, frameworks, datasets, and methodologies used to assess the performance of ML models. 
This encompasses various aspects, from the datasets used for evaluation to the metrics and software tools that facilitate the evaluation process. 
</p>

<ins>Key Questions</ins>

- Are the __raw evaluation files__ (for example, assignments for comparison and baselines, statistical code, confusion matrices) available? 
- If yes, __where__ (for example, URL) and __how__ (license)?

!!! example "From Example Publication"
	Not.


<br> 

<!--- From Docs: Bring Your Data -->
<p style='text-align: justify;'>
Time to practice on your work or a publication of your choice!
</p>


Steps:

1. Read the publication you have chosen.
2. Locate/highlight the areas of interest according to the DOME sections. (how many are covered? which are missing?)
3. Fill in this (*some kind of ready table template to be given*) with the information.
4. Discuss your results with the rest of the group. (do you see any common trends?)
5. Grab a beverage ☕ or a snack 🍩 to celebrate!

</p>
