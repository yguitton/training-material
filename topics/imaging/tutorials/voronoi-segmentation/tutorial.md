---
layout: tutorial_hands_on

title: Voronoi segmentation
zenodo_link: https://doi.org/10.5281/zenodo.3362976
questions:
  - How do I partition an image into regions based on which object they are nearest to (Voronoi segmentation)?
  - How should images be preprocessed before applying Voronoi segmentation?
  - How can I overlay two images?
  - How can Voronoi segmentation be used to analyze spatial relationships?
objectives:
  - How to perform Voronoi Segmentation in Galaxy.
  - How to extract a single channel from an image. 
  - How to overlay two images. 
  - How to count objectives in a layer map. 
time_estimation: 1H
key_points:
- Voronoi segmentation is a simple algorithm, chosen to give a starting point for working with image segmentation. 
- This tutorial exemplifies how a Galaxy workflow can be applied to data from several different domains. 
requirements:
  -
    type: "internal"
    topic_name: imaging
    tutorials:
      - imaging-introduction
contributors:
- evenmm
- rmassei
- kostrykin
- annefou
tags:
- imageanalysis
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

![HeLa cell image.](../../images/voronoi-segmentation/cell_image-B2-W00026-P00001-Z00000-T00000-dapi.png "HeLa cell image. <a href="https://zenodo.org/records/15172302">https://zenodo.org/records/15172302</a>)"){: width="100%"}

![Segmented HeLa cell image.](../../images/voronoi-segmentation/segmented_cell_image-B2-W00026-P00001-Z00000-T00000-dapi.png "Segmented HeLa cell image."){: width="100%"}

### Application to Earth Observation

In Earth observation, Voronoi segmentation is used to analyze spatial patterns and distributions in satellite or aerial images. By creating regions based on proximity to specific points, such as cities, vegetation clusters, or monitoring stations, Voronoi segmentation helps in studying how features are organized across a landscape. This method is particularly useful for mapping resource distribution, analyzing urban growth, monitoring vegetation patterns, or assessing land use changes. For instance, it can help divide an area into regions of influence around weather stations or identify how different land cover types interact spatially, aiding in environmental monitoring and planning.

![Tree crown image](../../images/voronoi-segmentation/tree_image_preview_2019_DELA_5_423000_3601000.png "Tree crown image. [https://zenodo.org/records/15172302](https://zenodo.org/records/15172302)"){: width="100%"}

![Segmented tree crown image](../../images/voronoi-segmentation/segmented_tree_image_preview_2019_DELA_5_423000_3601000.png "Segmented tree crown image."){: width="100%"}

> <agenda-title></agenda-title>
>
> In this tutorial, we will cover:
>
> 1. TOC
> {:toc}
>
{: .agenda}


## Data requirements 
Seeds: 
- White seeds on a black background.
- Format: .tiff

Image: 
- Preferrably lighter objects on a darker background for the mask to work well.
- Format: .tiff stored in [planar, not interleaved format](http://avitevet.com/uncategorized/when-to-use-it-interleaved-vs-planar-image-data-storage/). 


## Getting data
To run Voronoi segmentation, a seed image is required, which can be prepared manually or using an automatic tool, though the preparation process is outside the scope of this discussion. We have already prepared the seed image, and this is the one we are using for the Voronoi segmentation here. We apply image filters to enhance or suppress specific features of interest, such as edges or noise.

> <comment-title> Extracting seeds from an image </comment-title>
>
> To see how a seed image can be generated from a source image through smoothing and thresholding, see the 
> [Imaging introduction tutorial]({% link topics/imaging/tutorials/imaging-introduction/tutorial.md %}). 
{: .comment}

In the next step, you can download the data you need from Zenodo. The dataset contains both bioimaging data and earth observation data, so you can choose which data you want to apply the data to. 
In principle, this tutorial can be followed with any type of data provided that you have an image and another image with the corresponding seeds.  

> <hands-on-title> Data Upload </hands-on-title>
>
> 1. Create a new history for this tutorial. When you log in for the first time, an empty, unnamed history is created by default. You can simply rename it.
> 
>    {% snippet faqs/galaxy/histories_create_new.md %}
> 
> 2. Import {% icon galaxy-upload %} the following dataset from [Zenodo](https://zenodo.org/records/15172302). 
> 
>    ```
>    https://zenodo.org/records/15195377/files/images_and_seeds.zip
>    ```
> 
>    - **Important:** Choose the type of data as `zip`.
> 
>    The upload might take a few minutes. 
> 
>    {% snippet faqs/galaxy/datasets_import_via_link.md %}
>
> 3. {% tool [Unzip](toolshed.g2.bx.psu.edu/repos/imgteam/unzip/unzip/6.0+galaxy0) %} the image with the following parameters:
>    - {% icon param-file %} *"input_file"*: `images_and_seeds.zip`
>    - *"Extract single file"*: `Single file`
>    - *"Filepath"*: Choose one of the following: 
>        - HeLa cells: `images_and_seeds/HeLa_cell_image-B2--W00026--P00001--Z00000--T00000--dapi.tiff`
>        - Trees: `images_and_seeds/tree_image_2018_SJER_3_258000_4106000.tiff`
>    
> 4. Rename {% icon galaxy-pencil %} the resulting file as `image`.
>
> 5. Check that the datatype is correct.
>
>    {% snippet faqs/galaxy/datasets_change_datatype.md datatype="datatypes" %}
>
> 6. {% tool [Unzip](toolshed.g2.bx.psu.edu/repos/imgteam/unzip/unzip/6.0+galaxy0) %} the seed with the following parameters:
>    - {% icon param-file %} *"input_file"*: `images_and_seeds.zip`
>    - *"Extract single file"*: `Single file`
>        - HeLa cells: `images_and_seeds/HeLa_cell_seeds-B2--W00026--P00001--Z00000--T00000--dapi.tiff`
>        - Trees: `images_and_seeds/tree_seeds_2018_SJER_3_258000_4106000.png`
>
> 7. Rename {% icon galaxy-pencil %} the resulting file as `seeds`.
{: .hands_on}


## Generate an object mask from pixel intensity
In case there should be empty regions without cells in the image, we wish to constrain the single Voronoi regions to roughly the area where a cell is. 
Therefore, we first smooth the image to reduce the influence of noise, and then apply a threshold on the smoothed image to get a binary mask. 
> <comment-title> Mask vs seeds </comment-title>
> The process used to create a mask can also be used to make seeds, as in the 
> [Imaging introduction tutorial](https://training.galaxyproject.org/training-material/topics/imaging/tutorials/imaging-introduction/tutorial.html). 
{: .comment}

> <hands-on-title> Task description </hands-on-title>
> The image has three channels (red, green, blue). To generate a mask, we have to select a channel, for instance channel `0`. 
> 1. {% tool [Convert image format](toolshed.g2.bx.psu.edu/repos/imgteam/bfconvert/ip_convertimage/6.7.0+galaxy3) %} with the following parameters:
>    - {% icon param-file %} *"Input Image"*: `image`
>    - *"Extract series"*: `All series`
>    - *"Extract timepoint"*: `All timepoints`
>    - *"Extract channel"*: `Extract channel`
>        - *"Channel id"* `0`
>    - *"Extract z-slice"*: `All z-slices`
>    - *"Extract range"*: `All images`
>    - *"Extract crop"*: `Full image`
>    - *"Tile image"*: `No tiling`
>    - *"Pyramid image"*: `No Pyramid`
> 
>    <!-- - **Important:** If using the tree image, choose the type of data as `zip`. --> 
> 
> 2. Rename the output to `single channel image`
> 
> 
> 3. {% tool [Filter 2-D image](toolshed.g2.bx.psu.edu/repos/imgteam/2d_simple_filter/ip_filter_standard/1.12.0+galaxy1) %} with the following parameters:
>    - {% icon param-file %} *"Input Image"*: `single channel image`
>    - *"Filter type"*: `Gaussian`
>        - *"Sigma"*: `3`
> 
> 4. Rename the output to `smoothed image`.
> 
>
> 5. {% tool [Threshold image](toolshed.g2.bx.psu.edu/repos/imgteam/2d_auto_threshold/ip_threshold/0.18.1+galaxy3) %} with the following parameters:
>    - {% icon param-file %} *"Input Image"*: `smoothed image`
>    - *"Thresholding method"*: `Manual`
>        - *"Threshold value"*: `3.0`
> 
> 6. Rename the output to `mask`.
> 
{: .hands_on}

> <comment-title> How many channels does my image have? </comment-title>
> Note: If providing your own image, you can check how many channels your image has with the {% tool [Show image info](toolshed.g2.bx.psu.edu/repos/imgteam/image_info/ip_imageinfo/5.7.1+galaxy1) %} tool.
> The number of channels is listed as, e.g., `SizeC = 3` for the HeLa cell image or `SizeC = 3 (effectively 1)` for the tree image.
{: .comment}

> <comment-title> The value of Sigma and the Threshold value </comment-title>
> Note: Generating a robust mask is harder for images with more noise. 
> Since the tree image has more noise than the cell image, you may have to adjust the value of *"Sigma"* to achieve better results.
> You may also have to adjust the *"Threshold value"* in the last step.
{: .comment}


> <question-title></question-title>
>
> What is the purpose of the smoothing step? 
>
> > <solution-title></solution-title>
> >
> > The purpose of smoothing is to reduce noise. 
> > For seed generation, noise might lead to false seeds where there is no object. 
> > Smoothing also promotes connectedness within an object, where noise might make an object appear as two separate objects. 
> > For mask generation, the same principles apply.
> >
> {: .solution}
>
{: .question}


## Perform Voronoi segmentation based on the seeds 
> <hands-on-title> Task description </hands-on-title>
> We need to assign a unique label to each object in the seed image:
> 1. {% tool [Convert binary image to label map](toolshed.g2.bx.psu.edu/repos/imgteam/binary2labelimage/ip_binary_to_labelimage/0.5+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Binary Image"*: `seeds`
>    - *"Mode"*: `Connected component analysis`
> 
> 2. Rename the output to `label map`.
>
> 1. {% tool [Compute Voronoi tessellation](toolshed.g2.bx.psu.edu/repos/imgteam/voronoi_tesselation/voronoi_tessellation/0.22.0+galaxy3) %}. We use the label map to perform Voronoi segmentation. 
>    - {% icon param-file %} *"Input Image"*: `label map`
> 
> 2. Rename the output to `tessellation`.
>
{: .hands_on}

> <question-title></question-title>
>
> 2. How does the size of the seeds influence the Voronoi segmentation? 
>
> > <solution-title></solution-title>
> >
> > 2. A Voronoi segmentation partition a plane into regions based on [proximity to each member of a given set of objects](https://en.wikipedia.org/wiki/Voronoi_diagram). The algorithm is the same irregardless of whether the seeds are single points or objects with a spatial extension, but the size of the seeds will certainly alter the segmentation in some way. 
> >
> {: .solution}
>
{: .question}

## Apply the mask and visualize the segmentation
<!-- Combine the tesselation with the seeds and the mask to generate a better segmentation
# Combine the tesselation with the mask to reduce the size of the Voronoi segments
# Visualize the Voronoi segmentation by overlaying it on the original image -->
A Voronoi tesselation segments an image into non-overlapping segments that cover the entire image. 
This makes sure that segments do not overlap, but empty spaces between objects will be counted as part of the segment belonging to the nearest item. 
A more accurate segmentation can be achieved by using the mask to reduce the size of the Voronoi segments. 
This can be achieved with the following operation. 
> <hands-on-title> Task description </hands-on-title>
> Combine the tesselation with the seeds and the mask to generate a segmentation that limits the expanse of each segment: 
> 1. {% tool [Process images using arithmetic expressions with numpy](toolshed.g2.bx.psu.edu/repos/imgteam/image_math/image_math/1.26.4+galaxy2) %} with the following parameters:
>    - *"Expression"*: `tessellation * (mask / 255) * (1 - seeds / 255)`
>    - In *"Input images"*:
>        - {% icon param-repeat %} *"Insert Input images"*
>            - {% icon param-file %} *"Input Image"*: `tesselation`
>            - *"Variable for representation of the image within the expression"*: `tesselation`
>        - {% icon param-repeat %} *"Insert Input images"*
>            - {% icon param-file %} *"Input Image"*: `seeds`
>            - *"Variable for representation of the image within the expression"*: `seeds`
>        - {% icon param-repeat %} *"Insert Input images"*
>            - {% icon param-file %} *"Input Image"*: `mask`
>            - *"Variable for representation of the image within the expression"*: `mask`
>
> 2. Rename the output to `masked segmentation`.
>
> 3. {% tool [Colorize label map](toolshed.g2.bx.psu.edu/repos/imgteam/colorize_labels/colorize_labels/3.2.1+galaxy3) %}. 
>    - {% icon param-file %} *"Input Image"*: `masked segmentation`
>    - *"Radius of the neighborhood"*: `10` (works well for the HeLa cell image; may need adjustment for the tree image)
>    - *"Background label"*: `0`
> 
> 4. Rename the output to `colorized label map`
>
> 5. {% tool [Convert single-channel to multi-channel image](toolshed.g2.bx.psu.edu/repos/imgteam/repeat_channels/repeat_channels/1.26.4+galaxy0) %} with: 
>    - {% icon param-file %} *"Input Image"*: `single channel image`
>    - *"Number of channels"*: `3`
> 
> 6. Rename the output to `multi channel image`
> <!-- channel wrangling end -->
> 
> 7. {% tool [Overlay images](toolshed.g2.bx.psu.edu/repos/imgteam/overlay_images/ip_overlay_images/0.0.4+galaxy4) %} with the following parameters to overlay the Voronoi segmentation on the original image:  
>    - *"Type of the overlay"*: `Linear blending`
>    - {% icon param-file %} *"Image 1"*: `multi channel image`
>    - {% icon param-file %} *"Image 2"*: `colorized label map`
>    - *"Weight for blending"*: `0.5`
>
{: .hands_on}


## Count objects and extract image features
> <hands-on-title> Task description </hands-on-title>
> 1. {% tool [Count objects in label map](toolshed.g2.bx.psu.edu/repos/imgteam/count_objects/ip_count_objects/0.0.5-2) %}. 
>    - {% icon param-file %} *"Input Image"*: `tesselation`
>
> 1. {% tool [Extract image features with scikit-image](toolshed.g2.bx.psu.edu/repos/imgteam/2d_feature_extraction/ip_2d_feature_extraction/0.18.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Label map"*: `tesselation`
>    - *"Use the intensity image to compute additional features"*: `Use intensity image`
>        - {% icon param-file %} *"Intensity Image"*: `single channel image`
>    - *"Select features to compute"*: `All features`
>
{: .hands_on}


# Conclusion
This pipeline performs Voronoi segmentation and can be applied to datasets from any field as long as the input data satisfies the input data criteria. 
<!-- Sum up the tutorial and the key takeaways here. We encourage adding an overview image of the
pipeline used. --> 
If you need to apply this pipeline to several datasets, you can check out the associated workflow in the top panel, which contains all the steps in this tutorial. 
![Workflow image](../../images/voronoi-segmentation/Voronoi_workflow.png "Workflow image."){: width="100%"}
