---
title: Making a minor correction to any training material
box_type: tip
layout: faq
contributors: [philreeddata]
area: contributors
---

If you find a minor mistake in any GTN training material, we encourage you to propose a correction. For small changes such as typos, this can be done using the GitHub web editor. If you can implement the corrections yourself, this saves a lot of time for the editors. You can also be more confident that everyone will understand exactly what changes are being proposed, in the places where they are needed.

Outline of the steps:

1. Start from the page with the minor mistake.  
2. Open the page in the GitHub editor.  
3. Make the correction.  
4. Save the changes with a description of what you did.  
5. Send the proposal to the GTN team to check then apply the change.

In this example, we will show how to correct a typo in the metadata of a learning pathway. Note, this specific typo has now been corrected.

### 1. Start from the page with the minor mistake

1. From the [learning pathways page](/learning-pathways), you can see the tags below each pathway. Here, one of the pathways has a tag 'introcuction', which should be 'introduction'. 
2. Click to open the page.
3. At the top-right of the page, click **Settings** then **Propose a change or correction**. This will begin to open the page in the GitHub web editor.

### 2. Open the page in the GitHub editor  

1. You may be asked to sign into GitHub. (We will not cover how to register for a GitHub account here.)
2. If you have not previously done so, you will be asked to create a fork of the GTN training materials repository. This means, create a linked copy of the training materials in your personal GitHub account. Click **Fork this repository**.

### 3. Make the correction  

1. You will see the text and markup that makes up the training material. It uses a language called Markdown. 
2. In this example, we need to correct a line of the metadata at the top of the file (this is called the frontmatter). Type your correction.

### 4. Save the changes with a description of what you did

1. When you have finished making corrections, click the **Commit changes...** button. 
2. You will be asked to provide a brief summary of the changes you have made. In the box labeled **Commit message**, type a summary. 
3. You do not need to give an extended description here.
4. Click the **Propose changes** button.

### 5. Send the proposal to the GTN team to check then apply the change

1. You are taken to a page titled **Comparing changes**. You will see a list of the changes you have made. This appears as lines removed (beginning with a minus sign, in red) and lines added (beginning with a plus sign, in green).
2. Click the **Create pull request** button. This will open a pull request; this is a submission of your proposal that contains all the essential information for the editors and the platform to implement and apply the correction.
3. The title will be the same as the commit message you typed earlier.
4. Add a description which describes your changes. You can include links as required.
5. Click the **Create pull request** button. Your change has now been submitted, or, in GitHub terms, you have now opened a pull request. 
6. The pull request will need to be reviewed by a human. There are also some automated checks that will be run. After all this is completed, if your request is approved, it will be applied (or 'merged' in GitHub terms). 