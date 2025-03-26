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
time_estimation: 30M
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


> <tip-title>Creating, Editing and Importing Galaxy Workflows</tip-title>
>  [Read about creating, editing and importing  a workflow in this tutorial]({% link topics/galaxy-interface/tutorials/workflow-editor/tutorial.md %}).
>
{: .tip}

> <agenda-title></agenda-title>
>
> In this tutorial, we will cover:
>
> 1. TOC
> {:toc}
>
{: .agenda}


## Apply best practices to a workflow

To ensure that a workflow adheres to **best practices** and is **FAIR**, follow the different steps. You can apply them to **any workflow** of your choice or use the [**GTN Sequence Analysis - Mapping**](https://training.galaxyproject.org/training-material/topics/sequence-analysis/tutorials/mapping/tutorial.html) workflow as an example. 

> <hands-on-title>Import the workflow into Galaxy</hands-on-title>
>
> 1. **Copy the URL** (e.g. via right-click) of the workflow ["GTN - Sequence Analyses - Mapping (imported from uploaded file)"](https://training.galaxyproject.org/training-material/topics/sequence-analysis/tutorials/mapping/workflows/mapping.ga) or **download it** to your computer.
>
> 2. Import the workflow into Galaxy
>
>    {% snippet faqs/galaxy/workflows_import.md %}
>
{: .hands_on}

When **editing a workflow**, it’s essential to follow specific steps to ensure it adheres to **best practices** and is **FAIR**. You can follow [Adding workflow best practices guidelines](https://github.com/galaxyproject/iwc/blob/main/workflows/README.md#ensure-workflows-follow-best-practices) (the GIF with the 4 steps), you can refer to the [**Galaxy Best Practices FAQ**](https://training.galaxyproject.org/training-material/topics/galaxy-interface/tutorials/workflow-editor/tutorial.html#best-practices) or use these steps.

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
> 4. As you work through the workflow, make sure to **check and implement the following Best Practices**::
>   
>    - **Annotation**: Ensure the workflow is **fully annotated**. Each step should be well-explained with clear descriptions to help users understand the process.
>    - **Creator Information**: Specify the **creator(s)** of the workflow to ensure proper attribution and traceability.
>    - **License**: Define an appropriate **license**, such as **MIT** or **GNU Affero** (if you want a [copyleft](https://en.wikipedia.org/wiki/Copyleft)).
>    - **Parameter Connections**: Ensure all workflow steps are connected to **formal input parameters**.
>    - **Step Labels and Annotations**: Labels appear as titles above parameters when users run the workflow, and annotations provide additional help underneath. When **running tests** on the workflow, you will also need to refer to the label (use it as a key in yaml format). So it’s a good idea to keep the label short and simple and put all extra info into the annotation.
>    - **No Untyped Parameters**: Avoid using legacy **‘untyped’ parameters** (e.g., variables like `${report_name}`). All input parameters should be explicitly defined.
>    - **Labeled Outputs**: Ensure that all outputs that are being validated or checked are **properly labeled** for easier tracking and validation.
>
> 5. **Make the Workflow Public**: After confirming that all the best practices are applied, **make the workflow public**. This allows other users to access, reuse, and share the workflow in the Galaxy community.
>
{: .hands_on}

By following these steps and checking the side panel, you will ensure your **workflow adheres to best practices** and is **ready for public use**.


## Create test data for a workflow

## Upload test data to Zenodo

## Submit the workflow to IWC

## Conclusion


The Galaxy community also has a [guide on best practices for maintaining workflows](https://planemo.readthedocs.io/en/latest/best_practices_workflows.html). This guide includes the best practices from the Galaxy workflow panel, plus:
* adding tests to the workflow
* publishing the workflow on GitHub, a public GitLab server, or another public version-controlled repository
* registering the workflow with a workflow registry such as **WorkflowHub** or **Dockstore**

