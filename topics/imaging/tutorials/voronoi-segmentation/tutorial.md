---
layout: tutorial_hands_on

title: Voronoi segmentation
zenodo_link: https://zenodo.org/record/3362976/files/B2.zip
questions:
  - How do I partition an image into regions based on which object they are nearest to (Voronoi Segmentation)?
  - How should images be preprocessed before applying Voronoi segmentation?
  - How can I extract a single channel from an image? 
  - How can I overlay two images?
  - How can Voronoi segmentation be used to analyze spatial relationships and divide an image into distinct regions based on proximity?
objectives:
  - How to perform Voronoi Segmentation in Galaxy.
  - How to extract a single channel from an image. 
  - How to overlay two images. 
  - How to count objectives in a layer map. 
time_estimation: 1H
key_points:
- Voronoi segmentation is a simple algorithm, chosen to give a starting point for working with image segmentation
- This tutorial exemplifies how a Galaxy workflow can be applied to data from entirely different domains. 
requirements:
  -
    type: "internal"
    topic_name: imaging
    tutorials:
      - imaging-introduction
contributors:
- rmassei
- kostrykin
- annefou
- evenmm
tags:
- imaging
- segmentation
- voronoi
---


Voronoi segmentation is a technique used to divide an image or space into regions
based on the proximity to a set of defined points, called seeds or sites. Each 
region, known as a Voronoi cell, contains all locations that are closer to its 
seed than to any other. This approach is especially useful when analyzing spatial 
relationships, as it reveals how different areas relate in terms of distance and 
distribution. Voronoi segmentation is widely applicable for tasks where it's 
important to understand the proximity or neighborhood structure of points, such 
as organizing space, studying clustering patterns, or identifying regions of 
influence around each point in various types of data.


### Application to bioimage analysis

In bioimage analysis, Voronoi segmentation is a valuable tool for studying the 
spatial organization of cells, tissues, or other biological structures within an 
image. By dividing an image into regions around each identified cell or structure, 
Voronoi segmentation enables researchers to analyze how different cell types are 
distributed, measure distances between cells, and examine clustering patterns. This 
can provide insights into cellular interactions, tissue organization, and functional 
relationships within biological samples, such as identifying the proximity of immune 
cells to tumor cells or mapping neuron distributions within brain tissue.

### Application to Earth Observation

In Earth observation, Voronoi segmentation is used to analyze spatial patterns and distributions in satellite or aerial images. By creating regions based on proximity to specific points, such as cities, vegetation clusters, or monitoring stations, Voronoi segmentation helps in studying how features are organized across a landscape. This method is particularly useful for mapping resource distribution, analyzing urban growth, monitoring vegetation patterns, or assessing land use changes. For instance, it can help divide an area into regions of influence around weather stations or identify how different land cover types interact spatially, aiding in environmental monitoring and planning.

> <agenda-title></agenda-title>
>
> In this tutorial, we will cover:
>
> 1. TOC
> {:toc}
>
{: .agenda}

## Getting data
In the next step, you can download the data you need from Zenodo. The dataset contains both bioimaging data and earth observation data, so you can choose which data you want to apply the data to. 
In principle, this tutorial can be followed with any type of data provided that you have an image and another image with the corresponding seeds.  

> <hands-on-title> Data Upload </hands-on-title>
>
> 1. Create a new history for this tutorial. When you log in for the first time, an empty, unnamed history is created by default. You can simply rename it.
> 
>    {% snippet faqs/galaxy/histories_create_new.md %}
> 
> 2. Import {% icon galaxy-upload %} the following dataset from [Zenodo]( https://zenodo.org/records/15172302). 
>    - **Important:** Choose the type of data as `zip`.
> 
>    ```
>    https://zenodo.org/records/15195377/files/images_and_seeds.zip
>    ```
> 
>    The uplaod might take a few minutes. 
> 
>    {% snippet faqs/galaxy/datasets_import_via_link.md %}
>
> 3. {% tool [Unzip](toolshed.g2.bx.psu.edu/repos/imgteam/unzip/unzip/6.0+galaxy0) %} the image with the following parameters:
>    - {% icon param-file %} *"input_file"*: `images_and_seeds.zip`
>    - *"Extract single file"*: `Single file`
>    - *"Filepath"*: Choose one of the following: 
>        - `images_and_seeds/HeLa_cell_image-B2--W00026--P00001--Z00000--T00000--dapi.tiff`
>        - `images_and_seeds/tree_image_2018_SJER_3_258000_4106000.tiff`
>    
> 6. Rename {% icon galaxy-pencil %} the resulting file as `image`.
>
> 4. Check that the datatype is correct.
>
>    {% snippet faqs/galaxy/datasets_change_datatype.md datatype="datatypes" %}
>
> 5. {% tool [Unzip](toolshed.g2.bx.psu.edu/repos/imgteam/unzip/unzip/6.0+galaxy0) %} the seed with the following parameters:
>    - {% icon param-file %} *"input_file"*: `images_and_seeds.zip`
>    - *"Extract single file"*: `Single file`
>        - `images_and_seeds/HeLa_cell_seeds-B2--W00026--P00001--Z00000--T00000--dapi.tiff`
>        - `images_and_seeds/tree_seeds_2018_SJER_3_258000_4106000.png`
>
> 6. Rename {% icon galaxy-pencil %} the resulting file as `seed`.
{: .hands_on}


> <comment-title> Extracting seeds from an image </comment-title>
>
> To see how a seed image can be generated from a source image through smoothing and thresholding, see the 
> [Imaging introduction tutorial](https://training.galaxyproject.org/training-material/topics/imaging/tutorials/imaging-introduction/tutorial.html). 
{: .comment}

> <question-title></question-title>
>
> 1. What is the purpose of the smoothing step when using smoothing and a value threshold to generate seeds from an image? 
> 2. How does the size of the seeds influence the Voronoi segmentation? 
>
> > <solution-title></solution-title>
> >
> > 1. The purpose of smoothing is to reduce noise that might lead to false seeds where there is no item, and to promote connectedness within an object, which reduces the risk of birthing multiple seeds from the same object where noise disturbs the connectedness of the object. 
> > 2. A Voronoi segmentation partition a plane into regions based on [proximity to each member of a given set of objects](https://en.wikipedia.org/wiki/Voronoi_diagram). The algorithm is the same irregardless of the size of the seeds, but shrinking or enlargening the seeds will certainly alter the segmentation. 
> >
> {: .solution}
>
{: .question}


# Create a Voronoi segmentation workflow
We will build the Voronoi segmentation piece by piece, starting with image manipulation steps and building towards more complex steps, and ending with image visualization. 

> <hands-on-title> Task description </hands-on-title>
>
> 1. The image has three channels (red, green, blue) but the Voronoi segmentation only accepts a single channel. 
> Therefore, we have to select a channel, for instance channel `0`. 
> Apply {% tool [Convert image format](toolshed.g2.bx.psu.edu/repos/imgteam/bfconvert/ip_convertimage/6.7.0+galaxy3) %} with the following parameters:
>    - *"Extract series"*: `All series`
>    - *"Extract timepoint"*: `All timepoints`
>    - *"Extract channel"*: `Extract channel`: `0`
>    - *"Extract z-slice"*: `All z-slices`
>    - *"Extract range"*: `All images`
>    - *"Extract crop"*: `Full image`
>    - *"Tile image"*: `No tiling`
>    - *"Pyramid image"*: `Generate Pyramid`
>
> 1. {% tool [Convert binary image to label map](toolshed.g2.bx.psu.edu/repos/imgteam/binary2labelimage/ip_binary_to_labelimage/0.5+galaxy0) %} with the following parameters to assign a unique label to each object in the seed image:
>    - *"Mode"*: `Connected component analysis`
>
> 1. {% tool [Filter 2-D image](toolshed.g2.bx.psu.edu/repos/imgteam/2d_simple_filter/ip_filter_standard/1.12.0+galaxy1) %} with the following parameters:
>    - *"Filter type"*: `Gaussian`
>
>    To run Voronoi segmentation, a seed image is required, which can be prepared manually or using an automatic tool, though the preparation process is outside the scope of this discussion. We have already prepared the seed image, and this is the one we are using for the Voronoi segmentation here. We apply image filters to enhance or suppress specific features of interest, such as edges or noise.
>
>
> 1. {% tool [Convert single-channel to multi-channel image](toolshed.g2.bx.psu.edu/repos/imgteam/repeat_channels/repeat_channels/1.26.4+galaxy0) %}.
>
> 1. {% tool [Compute Voronoi tessellation](toolshed.g2.bx.psu.edu/repos/imgteam/voronoi_tesselation/voronoi_tessellation/0.22.0+galaxy3) %}. 
>
> 1. {% tool [Threshold image](toolshed.g2.bx.psu.edu/repos/imgteam/2d_auto_threshold/ip_threshold/0.18.1+galaxy3) %} with the following parameters:
>    - *"Thresholding method"*: `Manual`
>        - *"Threshold value"*: `3.0`
>
> 1. {% tool [Process images using arithmetic expressions](toolshed.g2.bx.psu.edu/repos/imgteam/image_math/image_math/1.26.4+galaxy2) %} with the following parameters:
>    - *"Expression"*: `tessellation * (mask / 255) * (1 - seeds / 255)`
>    - In *"Input images"*:
>        - {% icon param-repeat %} *"Insert Input images"*
>            - *"Variable for representation of the image within the expression"*: `tessellation`
>        - {% icon param-repeat %} *"Insert Input images"*
>            - *"Variable for representation of the image within the expression"*: `seeds`
>        - {% icon param-repeat %} *"Insert Input images"*
>            - *"Variable for representation of the image within the expression"*: `mask`
>
> 1. {% tool [Colorize label map](toolshed.g2.bx.psu.edu/repos/imgteam/colorize_labels/colorize_labels/3.2.1+galaxy3) %}.
>
>
> 1. {% tool [Overlay images](toolshed.g2.bx.psu.edu/repos/imgteam/overlay_images/ip_overlay_images/0.0.4+galaxy4) %} with the following parameters:
>    - *"Type of the overlay"*: `Linear blending`
>
{: .hands_on}

# Count objects and extract image features

> <hands-on-title> Task description </hands-on-title>
> 1. {% tool [Count objects in label map](toolshed.g2.bx.psu.edu/repos/imgteam/count_objects/ip_count_objects/0.0.5-2) %}. 
>
> 1. {% tool [Extract image features](toolshed.g2.bx.psu.edu/repos/imgteam/2d_feature_extraction/ip_2d_feature_extraction/0.18.1+galaxy0) %} with the following parameters:
>    - *"Use the intensity image to compute additional features"*: `Use intensity image`
>    - *"Select features to compute"*: `All features`
>
{: .hands_on}

# Conclusion

Sum up the tutorial and the key takeaways here. We encourage adding an overview image of the
pipeline used.