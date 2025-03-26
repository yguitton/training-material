---
layout: tutorial_hands_on

title: Workflow FAIRification
tags:
- workflows
- FAIR
questions:
- to do
objectives:
- to do
requirements:
- type: internal
  topic_name: galaxy-interface
  tutorials:
      - workflow-editor
time_estimation: 2H
key_points:
- to do
edam_ontology:
- to do
contributions:
  authorship:
  - clsiguret
  - nagoue
  - bebatut
  funding:
  - abromics
  - ifb
level: Intermediate
subtopic: workflows
---


Workflows are a powerful feature in Galaxy that allow you to link multiple steps of complex analysis. To maximize their impact, workflows should follow best practices that make them **FAIR: Findable, Accessible, Interoperable, and Reusable**.

The goal of this tutorial is to **prepare**, **integrate**, and **FAIRify Galaxy workflows** within the **Intergalactic Workflow Commission (IWC)**. The IWC ensures that workflows adhere to best practices for accessibility, interoperability, and reusability across the bioinformatics community. It also acts as a central hub for Galaxy workflows, automatically listing them in major registries like **Dockstore** and **WorkflowHub**, while ensuring that workflows are rigorously reviewed, tested, and updated with each new Galaxy release. Versioning, tool updates, and essential metadata improve the findability and usability of each workflow.

This tutorial will focus on applying FAIR principles to the **GTN Sequence Analysis - Mapping Workflow** to ensure it is well-documented, properly annotated, and easily shareable.


> <agenda-title></agenda-title>
>
> In this tutorial, we will cover:
>
> 1. TOC
> {:toc}
>
{: .agenda}


# Apply best practices to a workflow

To ensure that a workflow adheres to **best practices** and is **FAIR**, follow the different steps. You can apply them to **any workflow** of your choice or use the [**GTN Sequence Analysis - Mapping**]({% link topics/sequence-analysis/tutorials/mapping/tutorial.md %}) workflow as an example. 

> <hands-on-title>Import the workflow into Galaxy</hands-on-title>
>
> 1. **Copy the URL** (e.g. via right-click) of the workflow ["GTN - Sequence Analyses - Mapping (imported from uploaded file)"](https://training.galaxyproject.org/training-material/topics/sequence-analysis/tutorials/mapping/workflows/mapping.ga) or **download it** to your computer.
>
> 2. Import the workflow into Galaxy
>
>    {% snippet faqs/galaxy/workflows_import.md %}
>
{: .hands_on}

When **editing a workflow**, it’s essential to follow specific steps to ensure it adheres to **best practices** and is **FAIR**. You can follow [Adding workflow best practices guidelines](https://github.com/galaxyproject/iwc/blob/main/workflows/README.md#ensure-workflows-follow-best-practices) (the GIF with the 4 steps) and use these steps.

> <hands-on-title>Steps to Apply Best Practices</hands-on-title>
>
> 1. Start by opening the workflow you wish to {% icon galaxy-wf-edit %} **Edit**.
>
> 2. In the workflow menu bar, select the {% icon galaxy-wf-options %} **Workflow Options** dropdown menu.
>
> 3. From the dropdown menu, choose {% icon galaxy-wf-best-practices %} **Best Practices**. This will open a side panel showing any issues with the workflow and allow you to correct them.
>
>    - The side panel will highlight potential issues such as missing annotations, unconnected inputs, or other workflow problems.
>    - Green checks indicate that certain elements are already correctly defined (e.g., creator information, license).
>
>    {% snippet faqs/galaxy/workflows_best_practices.md %}
>
> 4. As you work through the workflow, make sure to **check and implement the following Best Practices**::
>   
>    - **Annotation**: Ensure the workflow is **fully annotated**. Each step should be well-explained with clear descriptions to help users understand the process.
>    - **Creator Information**: Specify the **creator(s)** of the workflow to ensure proper attribution and traceability.
>    - **License**: Define an appropriate **license**, such as **MIT** or **GNU Affero** (if you want a [copyleft](https://en.wikipedia.org/wiki/Copyleft)).
>    - **Parameter Connections**: Ensure all workflow steps are connected to **formal input parameters**.
>    - **Step Labels and Annotations**: Labels appear as titles above parameters when users run the workflow, and annotations provide additional help underneath.
>
>     > <comment-title></comment-title>
>     > When **running tests** on the workflow, you will also need to refer to the label (use it as a key in yaml format). So it’s a good idea to keep the label short and simple and put all extra info into the annotation.
>     {: .comment}
>
>    - **No Untyped Parameters**: Avoid using legacy **‘untyped’ parameters** (e.g., variables like `${report_name}`). All input parameters should be explicitly defined.
>    - **Labeled Outputs**: Ensure that all outputs that are being validated or checked are **properly labeled** for easier tracking and validation.
>
> 5. **Make the Workflow Public**: After confirming that all the best practices are applied, **make the workflow public**. This allows other users to access, reuse, and share the workflow in the Galaxy community.
>
>    {% snippet faqs/galaxy/workflows_publish.md %}
>
{: .hands_on}

By following these steps and checking the side panel, you will ensure your **workflow adheres to best practices** and is **ready for public use**.


# Create test data for a workflow

In this step, we will **create test data** that can be used **to verify and test the workflow**. The data should be small and simple, so it can interact with the workflow and generate results without excessive processing time. 

> <hands-on-title>Create a Galaxy History</hands-on-title>
>
> 1. **Create a new Galaxy history** for this analysis.
>
>    {% snippet faqs/galaxy/histories_create_new.md %}
>
> 2. **Rename the history** for clarity and easy identification.
>
>    {% snippet faqs/galaxy/histories_rename.md %}
>
{: .hands_on}

Now that we have a history set up, it's time to **upload the test data**. Ensure that the **test datasets are small in size** to optimize workflow testing.
For example, trim the FASTQ file to keep only a few sequences that will interact with the workflow.

> <hands-on-title>Upload Test Data</hands-on-title>
>
> 1. {% icon galaxy-upload %} **Upload** test data to the newly created history. 
>    
>    - From your computer with a **local file**
>    - From a URL with {% icon galaxy-wf-edit %} **Paste/Fetch data**: For the workflow "**GTN - Sequence Analyses - Mapping (imported from uploaded file)**", you can import `wt_H3K4me3_read1.fastq.gz` and `wt_H3K4me3_read2.fastq.gz` from [Zenodo](https://zenodo.org/record/1324070)
>
>    ```
>    https://zenodo.org/record/1324070/files/wt_H3K4me3_read1.fastq.gz
>    https://zenodo.org/record/1324070/files/wt_H3K4me3_read2.fastq.gz
>    ```
>
>    {% snippet faqs/galaxy/datasets_import_via_link.md %}
>
> 2. {% icon galaxy-eye %} **Preview the datasets** to verify that the uploaded data looks correct and is ready for analysis.
>
> 3. Once the data is uploaded and prepared, you can proceed with **running the workflow** using the uploaded test data.
>
>    {% snippet faqs/galaxy/workflows_run.md %}
>
> 4. Make the **history public** (*Tip 2.*)
>
>    {% snippet faqs/galaxy/histories_sharing.md %}
>
{: .hands_on}

Now that the test data has been uploaded and prepared, the next step is to ensure its accessibility by uploading it to [**Zenodo**](https://zenodo.org/) (if not already done). This will allow others to **easily retrieve and reuse the data** when running or validating the workflow.


# Make test data publicly available on Zenodo

This step is to ensuring that the data is **publicly accessible** and can be referenced in workflow documentation and tests.  

> <hands-on-title>Upload test data to Zenodo</hands-on-title>  
>
> 1. **Create an account** on [Zenodo](https://zenodo.org/) or **log in** using your **GitHub** account.  
> 2. Click on the **"+"** button at the top of the page and select **"New upload"**.  
> 3. **Drag and drop** the test dataset files into the upload area.  
> 4. **Fill in the metadata**:  
>    - **Resource type**: `Dataset`.  
>    - **Title**: `Dataset for "..." workflow ` 
>    - **Creator**: Add the relevant author(s).  
>    - **Description**: `This dataset is associated with the Galaxy workflow "..."`  
>    - **License**: Choose `GNU General Public License v3.0 or later`
> 5. Click **"Publish"** to make the dataset publicly available.  
>
{: .hands_on}  

Uploading test data to Zenodo ensures that it has a **permanent DOI**, making it easy to reference in workflow documentation, publications, and testing pipelines.  


# Submit the workflow to IWC

Once the workflow has been created, tested, and documented, it should be **submitted to IWC**. This ensures that the workflow is **publicly available, version-controlled, and indexed in workflow registries** like [WorkflowHub](https://workflowhub.eu/workflows/) and [Dockstore](https://dockstore.org/workflows/github.com/iwc-workflows/).  

> <hands-on-title>Submit the workflow to IWC</hands-on-title>  
>
> 1. **Install Planemo** (if not already installed) by following the [Planemo installation guide](https://planemo.readthedocs.io/en/stable/installation.html).  
>    - Open a terminal and run the first three command lines from the guide.  
>
> 2. **Fork the IWC GitHub repository**: Go to [IWC GitHub repo](https://github.com/galaxyproject/iwc) and fork it to your GitHub account.  
>
> 3. **Clone your fork locally**:  
>    ```bash
>    git clone https://github.com/yourusername/iwc.git
>    cd iwc
>    ```
>
> 4. **Create a new branch** for adding the workflow:  
>    ```bash
>    git checkout -b add-new-workflow
>    ```
>
> 5. **Create a new folder** inside the cloned repository for your workflow.  
>
> 6. **Run the workflow** in Galaxy.
>
>    {% snippet faqs/galaxy/workflows_run.md %}
>
> 7. **Extract the workflow invocation** using Planemo:  
>    - Get the workflow invocation given the [guidelines](https://github.com/galaxyproject/iwc/blob/main/workflows/README.md#generate-test-from-a-workflow-invocation).  
>    - Get your **Galaxy API key** from Galaxy.
>
>      {% snippet faqs/galaxy/preferences_admin_api_key.md %} 
>
>    - Extract the workflow with test data using:  
>      ```bash
>      planemo workflow_test_init --from_invocation WorkflowInvocation \
>         --galaxy_url GalaxyServerURL \
>         --galaxy_user_key yourGalaxyUserKey
>      ```
>
> 8. Edit the generated `tests.yml` file:  
>    - Add the **Zenodo path** from the test data upload step to each test input:  
>      ```yaml
>      https://zenodo.org/records/[zenodo_id]/files/[filename]
>      ```
>    - Ensure all test **output names** are included.  
>    - Use **assert commands** to to test the outputs (as in [XML file](https://docs.galaxyproject.org/en/latest/dev/schema.html#tool-tests-test-assert-command)).  
>
> 9. Create a `docker.yml` file:  
>    - Run:  
>      ```bash
>      planemo dockstore_init
>      ```
>    - Open the generated `docker.yml` and verify that author names and details are correct.  
>
> 10. Edit the `workflow.ga` file to include the **release number**. 
>      ```bash
>      ],
>      "format-version": "0.1",
>      "license": "GPL-3.0-or-later",
>      "release": "0.1",
>      "name": "NameOfTheWorkflow",
>      "steps": {
>      "0": {
>      ```
>
> 11. Create a `README.md` file inside the workflow folder (example: [README](https://github.com/galaxyproject/iwc/blob/main/workflows/microbiome/pathogen-identification/nanopore-pre-processing/README.md)).  
>
> 12. Create a `CHANGELOG.md` file inside the workflow folder:  
>     - If not auto-generated, create it manually with a date:  
>       ```md
>       # Changelog
>       
>       ## [0.1] yyyy-mm-dd
>       
>       First release.  
>       ```
>
> 13. **Test** the extracted workflow:  
>     ```bash
>     planemo test --galaxy_url GalaxyServerURL --galaxy_user_key yourGalaxyUserKey NameOfTheWorkflow.ga
>     ```
>
> 14. **Open a Pull Request (PR)** on the IWC GitHub repository to submit your workflow.  
>
{: .hands_on}  

The [**Best practices for workflows in GitHub repositories**]({% link topics/fair/tutorials/ro-crate-galaxy-best-practices/tutorial.md %}) GTN provides additional recommendations for structuring and maintaining workflows in Github.

Once the PR is reviewed and merged, the workflow will be available in **Galaxy's IWC collection** and indexed in registries like [**WorkflowHub**](https://workflowhub.eu/workflows/) and [**Dockstore**](https://dockstore.org/workflows/github.com/iwc-workflows/), making it **discoverable and reusable** by the community.


# Conclusion

By following this tutorial, you have ensured that your Galaxy workflow is **FAIR** and adheres to **best practices**. From importing and refining the workflow to creating test data and submitting it to the **IWC**, each step contributes to making workflows more **reliable, shareable, and reusable**.  

For further workflow optimization and maintenance, the **Galaxy community** provides a [comprehensive guide on best practices](https://planemo.readthedocs.io/en/latest/best_practices_workflows.html). This guide extends beyond the **best practices panel in Galaxy** and includes additional recommendations, such as:  

- **Adding automated tests** to validate workflow functionality.  
- **Publishing workflows** on platforms like GitHub, GitLab, or other public version-controlled repositories.  
- **Registering workflows** in well-known registries like [WorkflowHub](https://workflowhub.eu/workflows/) and [Dockstore](https://dockstore.org/workflows/github.com/iwc-workflows/), ensuring wider accessibility and discoverability.  

By continuously following these practices, you contribute to a **stronger, more open, and collaborative** bioinformatics community, where workflows are easily shared, improved, and adapted to new challenges.


