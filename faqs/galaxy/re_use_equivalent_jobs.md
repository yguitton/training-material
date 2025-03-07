---
title: How do I re-use equivalent jobs in Galaxy (aka Job Cache)?
area: user preferences
layout: faq
box_type: tip
contributors: [dadrasarmin]
---

Galaxy instances allow you to retrieve the results of running a tool from the cache (and hence almost immediately) if the tool with the exact same input and parameters has already been executed in your history. 
This is also true if another user used the same tool and inputs and made their history publicly available.
This is highly helpful in situations like training events. In such a case, the instructor might complete the tasks and make their results public. 
If the trainee activates this option in their account and uses the same input and parameters, they will immediately receive the results. This feature reduce the waiting time in the training sessions,
saves energy and computational resources, and therefore reducing environmental impact.

To activate this feature, take the following steps:

1. To activate this option for your account, click on your username in the top right part of the page.
- Select `Preferences`, which will appear after clicking.
- In your middle panel search for `Manage Information` and select them.
- Find the grey box: `Do you want to be able to re-use equivalent jobs?` 
- Within the box, change the slider saying `no` to `yes`.
- Scroll down to the bottom of the middle panel and select the `Save` button.
2. After completing the first step, you will notice a new option for each tool you want to run, above the `Run tool` button and below the `Email notification`. When you activate `Attempt to re-use jobs with identical parameters?`
  and click on the `Run tool`, Galaxy will check if you have access to a run with identical parameters. If so, the results will be displayed shortly thereafter.

At the moment, this feature only works with data stored in your own histories or `datasets` directory.
This function cannot be used to obtain results if the input files are acquired from the internet (for example, input files from Zenodo).
