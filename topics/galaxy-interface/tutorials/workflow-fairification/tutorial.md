---
layout: tutorial_hands_on

title: Annotate, prepare tests and publish on workflow registries Galaxy workflows 
tags:
- workflows
- FAIR
questions:
- How can a Galaxy workflow be annotated to improve reusability?
- What are the best practices for testing a Galaxy workflow?
- How can a Galaxy workflow be submitted to the Intergalactic Workflow Commission (IWC)?
objectives:
- Annotate a Galaxy workflows with essential metadata
- Annotate and apply best practices to data analysis Galaxy workflows for consistency and reusability
- Implement robust tests to ensure workflow reliability and accuracy
- Successfully integrate key data analysis Galaxy workflows into IWC, improving accessibility and usability
requirements:
- type: internal
  topic_name: galaxy-interface
  tutorials:
      - workflow-editor
time_estimation: 2H
key_points:
- Workflow annotation and best practices improve clarity and reusability
- Standardized metadata enhances workflow documentation
- Testing ensures workflow reliability and accuracy
- IWC submission enables version control and usability by the Galaxy community
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

Research data is accumulating at an unprecedented rate, presenting significant challenges for achieving fully reproducible science. As a result, implementing high-quality management of scientific data has become a global priority. One key aspect of this effort is the use of computational workflows, which describe the complex, multi-step methods used for data analysis. In Galaxy, workflows are a powerful feature that allows researchers to link multiple steps of complex analyses seamlessly. To maximize their impact, these workflows should adhere to best practices that make them **FAIR: Findable, Accessible, Interoperable, and Reusable**.

The FAIR principles —-Findable, Accessible, Interoperable, and Reusable—- provide practical guidelines for enhancing the value of research data:

- **Findable**: Easy to locate through rich metadata and unique identifiers.
- **Accessible**: Stored in a way that allows them to be retrieved by those who need them.
- **Interoperable**: Usable across different systems and platforms without extensive adaptation.
- **Reusable**: Well-documented and clearly licensed to enable reuse in different contexts.

Applying these principles to workflows is equally important for good data management:

- **Enhanced Discoverability**: Well-annotated and documented workflows are easier to find, making them more likely to be used and cited.
- **Improved Reproducibility**: Standardized and tested workflows ensure that analyses can be reproduced, validating research findings.
- **Community Collaboration**: Sharing workflows through centralized registries fosters collaboration and innovation within the bioinformatics community.
- **Sustainability**: Regular updates and versioning ensure that workflows remain compatible with the latest tools and Galaxy releases, extending their lifespan and utility.

While making a workflow FAIR might seem complicated ({% cite wilkinson2025applying %}, {% cite goble2020fair %}), publications like "Ten quick tips for building FAIR workflows" ({% cite de2023ten %}) provide practical guidelines to simplify the process:

![This image provides ten quick tips for building FAIR workflows, focusing on findability (registering the workflow and describing it with rich metadata), accessibility (making source code available in a public repository and providing example input data and results), interoperability (adhering to file format standards and making the workflow portable), and reusability (providing a reproducible computational environment, adding a configuration file with defaults, modularizing the workflow, and offering clear documentation).](./images/journal.pcbi.1011369.g001.PNG "Ten quick tips for building FAIR workflows. Source: {% cite de2023ten %}")

Using Galaxy as a workflow management system, many of these tips (all related to **Interoperability** and **Reusability**) are already fulfilled:
- Tip 5 (**Interoperability**): *"The tools integrated in a workflow should adhere to file format standards."*
- Tip 6 (**Interoperability**): *"Make the workflow portable."*
- Tip 7 (**Reusability**): *"Provide a reproducible computational environment to run the workflow."*
- Tip 8 (**Reusability**): *"Add a configuration file with defaults."*
- Tip 9 (**Reusability**): *"Modularize the workflow."*

In this tutorial, we will demonstrate how to fulfill the remaining tips:
- Tip 1 (**Findability**): *"Register the workflow."*
- Tip 2 (**Findability**): *"Describe the workflow with rich metadata."*
- Tip 3 (**Accessibility**): *"Make source code available in a public code repository."*
- Tip 4 (**Accessibility**): *"Provide example input data and results along with the workflow."*
- Tip 10 (**Reusability**): *"Provide clear and concise workflow documentation."*

To illustrate the process, we will use the **workflow from the [Mapping tutorial]({% link topics/sequence-analysis/tutorials/mapping/tutorial.md %})** as an example.

> <agenda-title></agenda-title>
>
> In this tutorial, we will cover:
>
> 1. TOC
> {:toc}
>
{: .agenda}

# Prepare the workflow

Here, we will use the **workflow from the [Mapping tutorial]({% link topics/sequence-analysis/tutorials/mapping/tutorial.md %})** but you can use your own workflow.

> <hands-on-title>Import the workflow into Galaxy</hands-on-title>
>
> 1. **Copy the URL** (e.g. via right-click) of the workflow ["GTN - Sequence Analyses - Mapping (imported from uploaded file)"](https://training.galaxyproject.org/training-material/topics/sequence-analysis/tutorials/mapping/workflows/mapping.ga) or **download it** to your computer.
>
> 2. Import the workflow into Galaxy
>
>    {% snippet faqs/galaxy/workflows_import.md %}
>
{: .hands_on}

# Annotate the Galaxy workflow with essential metadata

The first step to FAIRify a workflow is to annotate it with essential metadata:
- 

To ensure that a workflow adheres to **best practices** and is **FAIR**, follow the different steps. You can apply them to **any workflow** of your choice or use the [**GTN Sequence Analysis - Mapping**]({% link topics/sequence-analysis/tutorials/mapping/tutorial.md %}) workflow as an example. 



When **editing a workflow**, it’s essential to follow specific steps to ensure it adheres to **best practices** and is **FAIR**. You can follow [Adding workflow best practices guidelines](https://github.com/galaxyproject/iwc/blob/main/workflows/README.md#ensure-workflows-follow-best-practices) (the GIF with the 4 steps) and use these steps.

The first step to FAIRify a Galaxy workflow is to fulfill Tip 2 (**Findability**): *"Describe the workflow with rich metadata"*. Describing the workflow with rich metadata helps both humans and machines understand its purpose, facilitating discovery by search engines. Galaxy allows to associate workflows with metadata directly in its interface:

> <hands-on-title></hands-on-title>
>
> 1. Go to the workflow page
> 2. Open the workflow editor for the workflow
>
{: .hands_on}

On the left side of the workflow editor (or right side for older Galaxy version for clicking on {% icon galaxy-pencil %} **Edit Attributes**), some workflow metadata should appear.

> <question-title></question-title>
>
> 1. What is the name of the workflow?
> 2. What is the version?
>
> > <solution-title></solution-title>
> > 1. "GTN - Sequence Analyses - Mapping (imported from uploaded file) (imported from URL)"
> > 2. Version 1
> {: .solution}
{: .question}

Metadata should include details about the workflow's components and clearly outline its purpose, scope, and limitations. This ensures the workflow is easily findable and understandable. 

> <question-title></question-title>
>
> Which metadata is supported in Galaxy workflow interface?
>
> > <solution-title></solution-title>
> > Galaxy workflow interface supports:
> > - Name
> > - Version
> > - Annotation: These notes will be visible when this workflow is viewed.
> > - License
> > - Creator: Either a person or an organization. 
> > - Tags: Apply tags to make it easy to search for and find items with the same tag. 
> {: .solution}
{: .question}

Galaxy workflow interface supports some metadata. Are they enough to fulfill Tip 2 and also Tip 1 *"Register the workflow."*. WorkflowHub, a workflow registry we will explain more later, supports the [following metadata](https://about.workflowhub.eu/docs/metadata-list/):

Name | Description | Mandatory
--- | --- |
**Title** | This field is mandatory and is with some workflow types pre-filled with the title of the workflow. | Yes
**Description** | If a CWL (abstract) file is given, the description will be parsed automatically out of the doc attribute. In any other case this field can be used to write some documentation that will be shown on the workflow page. | No
**Source** | If the workflow came from an external repository (i.e. GitHub), you can include its original URL here. | No
**Maturity** | This field can be used to specify in which maturity state the workflow is. The two available options are: `work-in-progress`, `stable` | No
**Teams** | Every workflow registration is linked to one or more teams. | Yes
**Licence** | The standard licence is Apache Software Licence 2.0. If you did not make the workflow yourself, be sure that the licence corresponds to the licence where you took the workflow from (for example github licences). | No
**Sharing** | Specify who can view the summary, get access to the content, and edit the Workflow. This is possibly already filled in according to the selected project. | No
**Tags** | Choose an appropriate tag for your workflow. Please check if your tag is already available and use the existing one if so. If you make a new tag, keep it simple without capitals or spaces. For example all new covid-19 workflows need to be tagged with covid-19. | No
**Creators** | This is an important section where all the people that were involved in making / publishing this workflow are listed. | No

> <question-title></question-title>
>
> 1. Which WorkflowHub metadata is supported in Galaxy workflow interface?
> 2. Which values should we put for our workflow?
>
> > <solution-title></solution-title>
> >
> > Workflow metadata | Galaxy metadata | Mapping workflow value
> > --- | --- | ---
> > Title | Name | Quality control and mapping
> > Description | Annotation | Workflow runs quality control and mapping of paired-end short-reads data.
> > Source | *Not supported in Galaxy workflow interface* | 
> > Teams | *Not supported in Galaxy workflow interface* | 
> > License | License | MIT License
> > Sharing | *Not supported in Galaxy workflow interface* | 
> > Tags | Tags | `sequence-analysis`, `mapping`
> > Creators | Creator | 
> >
> {: .solution}
{: .question}

Let's annotate the workflow

> <hands-on-title>Steps to Apply Best Practices</hands-on-title>
>
> 1. Add a proper title in **Name**
> 2. Add a description in **Annotation**
> 3. Select a license in **License**
>
>    > <comment-title></comment-title>
>    > The most appropriate **license** are **MIT** or **GNU Affero** (if you want a [copyleft](https://en.wikipedia.org/wiki/Copyleft)).
>    {: .comment}
>
> 4. Add creators in **Creator** with their name and a unique identifier (typically an orcid.org ID)
> 5. Add tags in **Tags**
> 6. Save the workflow
{: .hands_on}


Tip 2 is now fulfilled. We can now move toward the other left tips:

- Tip 1 (**Findability**): *"Register the workflow."*
- Tip 3 (**Accessibility**): *"Make source code available in a public code repository."*
- Tip 4 (**Accessibility**): *"Provide example input data and results along with the workflow."*
- Tip 10 (**Reusability**): *"Provide clear and concise workflow documentation."*

   > <details-title>Add step descriptions to fulfill Tip 10</details-title>
   > 
   > Tip 10 (**Reusability**): *"Provide clear and concise workflow documentation."*
   {: .details}

To achive Tip 1 and register the workflow, we will first need to fulfill Tips 3 and 4. Before, we need to be sure that the workflow adheres to best practices for Galaxy workflows.

# Adhere to best practices for Galaxy workflows

There are a number of things the user interface of Galaxy will allow that are not considered best practices because they make the workflow harder to test, use within subworkflows and invocation reports, and consume via the API. It is easier to use workflows in all of these contexts if they stick to the [best practices developed by the commmunity](https://planemo.readthedocs.io/en/latest/best_practices_workflows.html).

> <hands-on-title>Check alignment with best practices</hands-on-title>

> 2. Click on {% icon galaxy-wf-best-practices %} **Best Practices** on the right
>
>    
>
>    {% snippet faqs/galaxy/workflows_best_practices.md %}
>
>
{: .hands_on}

A side panel will open showing any issues with the workflow and allow you to correct them.

- The side panel will highlight potential issues such as missing annotations, unconnected inputs, or other workflow problems.
- Green checks indicate that certain elements are already correctly defined (e.g., creator information, license).

By following these steps and checking the side panel, you will ensure your **workflow adheres to best practices** and is **ready for public use**.

>    - **No Untyped Parameters**: Avoid using legacy **‘untyped’ parameters** (e.g., variables like `${report_name}`). All input parameters should be explicitly defined.
>    - **Labeled Outputs**: Ensure that all outputs that are being validated or checked are **properly labeled** for easier tracking and validation.
>


Workflows should define explicit, labeled outputs. While Galaxy does not require this, declaring and labeling outputs offers significant advantages. A workflow with clearly defined outputs provides an explicit interface, making it easier to generate reports, test the workflow, and document them.

> <hands-on-title>Add labels to outputs</hands-on-title>
>
> 1. Make sure that 
{: .hands_on}

> <hands-on-title>Add labels to inputs</hands-on-title>
>
> 1. Make sure that 
{: .hands_on}


> <hands-on-title>Add labels to inp</hands-on-title>
> 5. **Make the Workflow Public**: After confirming that all the best practices are applied, **make the workflow public**. This allows other users to access, reuse, and share the workflow in the Galaxy community.
>
>    {% snippet faqs/galaxy/workflows_publish.md %}
{: .hands_on}

# Prepare tests to validate the functionality of the workflow

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


## Make test data publicly available on Zenodo

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


# Publish the workflow to workflow registries by contributing to IWC

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


ensure your workflows are reviewed, tested, and maintained.