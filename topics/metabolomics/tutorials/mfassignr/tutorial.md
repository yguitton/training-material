---
layout: tutorial_hands_on

title: Molecular formula assignment and recalibration with MFAssignR package
zenodo_link: https://zenodo.org/records/13768009
questions:
- What are the main steps of untargeted metabolomics LC-MS data pre-processing?
- How to analyze complex mixture samples using the MFAssignR package?
objectives:
- To learn about the main steps in the pre-processing of untargeted metabolomics LC-MS data.
- To try on-hands analysis using the model data.
requirements:
  -
    type: "internal"
    topic_name: metabolomics
    tutorials:
      - introduction
      - lcms-dataprocessing
time_estimation: 2H
key_points:
- The take-home messages
- They will appear at the end of the tutorial
contributors:
- Kristina Gomoryova
- hechth

---

This training covers the multi-element molecular formula (MF) assignment using the MFAssignR tool. It was originally developed by {% cite Schum2020 %} and contains several functions including noise assessment, isotope filtering, internal mass recalibration and formula assignment. 

MFAssignR workflow is composed of several steps:

1. Run KMDNoise() to determine the noise level for the data.
2. Check effectiveness of S/N threshold using SNplot().
3. Use IsoFiltR() to identify potential 13C and 34S isotope masses.
4. Using the S/N threshold, and the two data frames output from IsoFiltR(), run MFAssignCHO() to assign MF with C, H, and O to assess the mass accuracy.
5. Use RecalList() to generate a list of the potential recalibrant series.
6. After choosing recalibrant series, use Recal() to recalibrate the mass lists.
7. Assign MF to the recalibrated mass list using MFAssign().
8. Check the output plots from MFAssign() to evaluate the quality of the assignments.

We can illustrate the workflow also on the following scheme:

![workflow_graphical](images/mfassignr_scheme.png)

Let's dive now into the individual steps and explain all the inputs, parameter settings and outputs.

> <agenda-title></agenda-title>
>
> In this tutorial, we will cover:
>
> 1. TOC
> {:toc}
>
{: .agenda}

# Data import

At the very beginning, we need to import the dataset we will be using. MFAssignR requires an input data, which have as the first column mass, in the second column there is intensity and optionally, the third column can contain retention time. In our case, we will start with a raw mass list, which was measured in a negative ESI mode.

> <hands-on-title> Upload data </hands-on-title>
>
> 1. Create a new history for this tutorial and give it a name.
>
>    {% snippet faqs/galaxy/histories_create_new.md %}
>
> 2. Import the files from [Zenodo]({{ https://zenodo.org/records/13768009 }}):
>
>    ```
>    https://zenodo.org/api/records/13768009/files/mfassignr_input.txt/content
>    ```
>
>    {% snippet faqs/galaxy/datasets_import_via_link.md %}
>
>    {% snippet faqs/galaxy/datasets_import_from_data_library.md %}
>
> 3. Set the format of the dataset to 'tabular'. 
>
>    {% snippet faqs/galaxy/datasets_change_datatype.md datatype="tabular" %}
>
> 4. We can now view our dataset, and ensure, that it has a correct input format.
>
>
{: .hands_on}

# Noise assessment

Having our input data in the workspace, we can now start with the analysis!

The first step is the noise assessment, which allows us to avoid both false positives (if noise is underestimated) and false negatives (if noise is overestimated). For this purpose, we will be using two functions: **MFAssignR HistNoise** and **MFAssignR KMDNoise** and we can additionally visualize the result using the **MFAssignR SNplot** function. The main goal is to find a signal-to-noise (S/N) threshold, which we will use later on. 

## HistNoise

We will firstly assess the noise using the HistNoise function. This function attempts to find a point where noise peaks give way to analyte signal using a histogram of the natural log intensities in the measured raw mass spectrum. 

> <hands-on-title> Noise assessment using HistNoise </hands-on-title>
>
> 1. {% tool [MFAssignR HistNoise](toolshed.g2.bx.psu.edu/repos/recetox/mfassignr_histnoise/mfassignr_histnoise/1.1.1+galaxy0) %} with the following parameters:
>
> - {% icon param-file %}  *"Input data"*: `mfassignr_input.txt` (Input dataset)
> - {% icon param-file %} *"SNthreshold"*: `0`
> - {% icon param-file %} *"Binwidth of histogram"*: `0.01`
>
>
>    > <warning-title>Important!</warning-title>
>    >
>    > Always run the HistNoise on the raw data itself and not on already denoised data, in that case it will not work.
>    {: .warning}
>
{: .hands_on}

On the output, we can see we got a **noise level** and a **histogram**, where by red a noise is depicted in red, and signal is depicted in blue. HistNoise can fail to separate the distributions if the analyte signal tapers into the noise. In that case, it is better to use the KMDNoise function.

> <question-title></question-title>
>
> 1. What is the noise level estimated by HistNoise function?
>
> > <solution-title></solution-title>
> >
> > 1. Using our model data, the estimated noise is 317.3483.
> >
> {: .solution}
>
{: .question}

## KMDNoise

When the KMD (Kendrick Mass Defect) is calculated for all peaks in the mass spectrum, there will be clear separation of more intense analyte peaks, and low intense noise peaks. To isolate the noise region, we can use the KMD limits of chemically feasible molecular formulas in conjunction with the calculation of slope of a KMD plot using a linear equation y = 0,1132x + b, where y is the KMD value, x the measured ion mass and b an y-intercept. To provide more accurate assessment, two lines are with different y-intercepts are selected (we will set this lower and upper y-limit below). Once the noise region is isolated, a noise level will be estimated as average intensity of peaks within that region.

When running the function, we can stick with the default values: upper limit for the y intercept is set to 0.2, so that it does not interact with any potentially double-charged peaks, lower limit of the y-intercept value is set to 0.05 to ensure no analyte peaks are incorporated into the noise estimation. Both upper and lower x intercept limits are optional and will be set to minimum and maximum mass in the spectrum if not specified. 

> <hands-on-title> Noise assessment using KMDNoise </hands-on-title>
>
> 1. {% tool [MFAssignR KMDNoise](toolshed.g2.bx.psu.edu/repos/recetox/mfassignr_histnoise/mfassignr_kmdnoise/1.1.1+galaxy0) %} with the following parameters:
>
>- {% icon param-file %} *"Input data"*: `mfassignr_input.txt` (Input dataset)
>- {% icon param-file %} *"upper limit for the y intercept"*: `0.2`
>- {% icon param-file %} *"lower limit for the y intercept"*: `0.05`
>   
>
{: .hands_on}

The function outputs a **KMD plot**, where the noise area is separated in between red lines, and a **noise estimate**. The noise estimate we can then multiply with a user-defined signal-to-noise ratio, typically 3-10 in order to remove low intensity m/z values.

![KMD plot](images/KMDplot.png)

> <question-title></question-title>
>
> 1. What is the noise level estimated by KMDNoise function?
>
> > <solution-title></solution-title>
> >
> > 1. Using our model data, the estimated noise is 346.0706.
> >
> >
> {: .solution}
>
{: .question}

## SNplot

We can now check the effectiveness of the S/N threshold using SNplot, which plots the mass spectrum with the masses below and above the chosen threshold, where the noise is indicated by red.

The *cut* parameter can be computed as estimated noise level * user defined S/N threshold, so if we got 346.0706 as a noise level from KMDnoise, we can multiply it by 6, which gives us 2076.
*Mass* parameter defines a centerpoint to look at the mass spectrum.
*Parameter window.x* sets the +/- range around the mass centerpoint, default is 0.5
*Parameter window.y* sets the y-axis for the plot, when cut is multiplied by this value.

> <hands-on-title> Plot the SNplot </hands-on-title>
>
> 1. {% tool [MFAssignR SNplot](toolshed.g2.bx.psu.edu/repos/recetox/mfassignr_snplot/mfassignr_snplot/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Input data"*: `mfassignr_input.txt` (Input dataset)
>    - *"cut"*: `2076.0`
>    - *"mass"*: `301.0`
>    - *"window.x"*: `50.0`
>
{: .hands_on}

![SNplot](images/SNplot.png)

Based on the SNplot, we can see that the noise - indicated in red - is effectively separated by the horizontal line, meaning we can further use the 346 value as the S/N threshold.


# Isotope filtering

Next step is identification of probable isotopic ion masses containing 1-2 13C or 34S from monoisotopic massed in order to prevent incorrect interpretation of molecular composition. For this, we will use the IsoFiltR function.

After performing isotopic filtering, two tables are outputted, one containing the isotopic masses and one containing the monoisotopic and all masses that did not have a matching isotopic mass. In complex mixtures, a mass can be classified as both monoisotopic and isotopic; in those cases it is included in both output tables and classified after the MF assignment.

We will change only the S/N ratio parameter, otherwise we can follow with the default settings.

> <hands-on-title> Isotope filtering using IsoFiltR </hands-on-title>
>
> 1. {% tool [MFAssignR IsoFiltR](toolshed.g2.bx.psu.edu/repos/recetox/mfassignr_isofiltr/mfassignr_isofiltr/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Input Peak Data"*: `mfassignr-input.txt` (Input dataset)
>    - *"Signal-to-Noise Ratio"*: `346.0`
>
>    > <comment-title> SN ratio </comment-title>
>    >
>    > How about the noise multiplier?
>    {: .comment}
>
{: .hands_on}

# Preliminary molecular formula assignment

Once we have denoised data and we have identified the potential 13C and 34S masses, we can start with the preliminary MF assignment, using the **MFAssignCHO** function. This function assigns MF only with CHO elements to assess the mass accuracy, and therefore it's much quicker than the main MFAssign function. 

Let's use the MFAssignCHO function. On the input, we will need the output of IsoFiltR function, a dataframe of monoisotopic masses, and also the dataframe containing isotopic masses. Furthermore, we select in which ion mode we measured the data (positive or negative) and we set the signal-to-noise threshold - based on the noise estimate we obtained from the KMDNoise or HistNoise functions multiplied by a specific value - recommended is 3, 6 or 9. Finally, based on the acquisition range, we set the lowMW and highMW, and also the allowed ppm error. Other parameters we can leave in default settings. 

> <hands-on-title> Preliminary MF assignment with MFAssignCHO </hands-on-title>
>
>
> 1. {% tool [MFAssignR MFAssignCHO](toolshed.g2.bx.psu.edu/repos/recetox/mfassignr_mfassigncho/mfassignr_mfassignCHO/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Data frame of monoisotopic masses"*: `mono_out` (output of **MFAssignR IsoFiltR** {% icon tool %})
>    - {% icon param-file %} *"Data frame of isotopic masses"*: `iso_out` (output of **MFAssignR IsoFiltR** {% icon tool %})
>    - *"ppm_err"*: `3`
>    - *"Ion mode"*: `negative`
>    - *"SN ratio"*: `6`
>    - *"Estimated noise"*: `346.0`
>    - *"Lower limit of molecular mass to be assigned"*: `50.0`
>    - *"Upper limit of molecular mass to be assigned"*: `1000.0`
>
>
{: .hands_on}

On the output, we get several dataframes: unambiguous assignments, ambiguous assignments and a dataframe containing unassigned masses. Additionally, several plots are available, such as MSAssign showing a mass spectrum highlighting assigned and unassigned masses, errorMZ showing the relationship between absolute error (in ppm) and ion mass, van Krevelen plot and a mass spectrum colored by molecular group.

![errorMZ](images/errorMZ.png)
![Van Krevelen plot](images/vankrevelen.png)
![MS groups](images/MSgroups.png)
![msassign](images/msassign.png)

# Recalibration
The next step is recalibration, for which we will use three consecutive functions, RecalList, FindRecalSeries and Recal. 

## RecalList

Firstly, we will generate a table containing potential recalibrant CH2 homologous series using the RecalList function. 
As in input, we will use the Unambig1 dataframe which we generated in the MFAssignCHO function:

> <hands-on-title> Finding recalibrant series </hands-on-title>
>
> 1. {% tool [MFAssignR RecalList](toolshed.g2.bx.psu.edu/repos/recetox/mfassignr_recallist/mfassignr_recallist/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Input data"*: `Unambig` (output of **MFAssignR MFAssignCHO** {% icon tool %})
>
>
{: .hands_on}

On the output, we get a dataframe containing CH2 homologous series that contain more than 3 members. Let's dive more into what metrics are available:

- Series - reports the homologous series according to class, adduct, and DBE. The format is "class_adduct_DBE", for example a homologous series with class = "O6, adduct of Na+, and DBE = 4" would be "O6_Na_4"
- Number Observed - reports the number of members of each homologous series.
- Series Index - represents the order of the series when ordered by length of homologous series.
- Mass Range - reports the minimum and maximum mass for the compounds within a homologous series.
- Tall Peak - reports the mass of the most abundant peak in each series.
- Abundance Score - reports the percentage difference between the mean abundance of a homologous series and the median abundance within the mass range the "Tall Peak" falls in (for example m/z 200-300). A higher score is generally better.
- Peak Score - This column compares the intensity of the tallest peak in a given series to the second tallest peak in the series. This comparison is calculated by log10(Max Peak Intensity/Second Peak Intensity). The closer to 0 this value is the better, in general.
- Peak Distance - This column shows the number of CH2 units between the tallest and second tallest peak in each series. In general, it is better for the value to be as close to 1 as possible.
- Series Score - This column compares the number of actual observations in each series to the theoretical maximum number based on the CH2 homologous series. The closer to one this value is, the better.

Combined, these series should cover the full mass spectral range to provide the best overall recalibration. The best series to choose are generally long and combined have a “Tall Peak” at least every 100 m/z.

Currently, it is up to user to choose the most suitable recalibrant series which will be used for the recalibration in the next Recal step. It is possible to choose up to 10 series and they should indeed span over whole range of m/z - often an error is thrown to add more series in case there would be gaps, or the chosen series would have a good scores but would be way too alike. 

The series can be chosen either visually by the user, or using the **FindRecalSeries** function, which we will describe in the next section.

## FindRecalSeries

This function attempts to help with selecting the most appropriate recalibration series. The input to FindRecalSeries() is the output of RecalList, so all series without particular order. 

The number of series provided by **RecalList** is quite extensive: using the model data, we get 225 series. Because computing all 10-element combinations out of 225 series would be very computationally expensive (we are at 7.480909295 E+16 possible combinations!), we firstly do pre-filtering:

- We keep only the series with **Abundance.Score** > 0 - we want this parameter to be as high as possible, so we can very well get rid of negative values,
- **Peak.Distance** < 2. Here, we want this parameter as close to 1 as possible, and although majority of series do have it indeed very close to 1, there are also some clear outliers around 4 which we can confidently filter out.

Now we get out of 225 series to 94, and if we further restrict the Abundance.Score to 100, we end up with 33 series, where computing any combination is much easier.

On the input, we need except for the RecalSeries output from RecalList also **global_min** and **global_max**, which correspond to the detection limit of instrument and are important for computing the coverage. Furthermore, we set the **abundance_score threshold**, **peak_distance_threshold** and **coverage_threshold**, which we already described above.

Another two important parameters are **number_of_combinations** and **fill_series**. Number_of_combinations sets how many combinations we want to compute and for which we will get the scoring. Default value is 5, which is a nice "price-performance ratio". Keep in mind, that the more combinations you set, the longer computing time is expected, growing exponentially.

To tackle this problem, we introduced the **fill_series** parameter. By default it is set to FALSE, meaning that only number of series corresponding to the number_of_combinations are returned. If we thus set the number_of_combinations to 5, only the 5-altogether best combination of series is returned. If we set this parameter to TRUE, the series will be filled up to 10, which can be taken by the Recal function, by sorting all series according to the final score, and taking the 10 best scoring unique series. This provides a more precise approach for the recalibration and also better coverage, while still keeping the computing time as low as possible.

> <hands-on-title> Selecting most suitable series </hands-on-title>
>
> 1. {% tool [MFAssignR FindRecalSeries](mfassignr_findRecalSeries) %} with the following parameters:
>    - {% icon param-file %} *"Input data"*: `recal_series` (output of **MFAssignR RecalList** {% icon tool %})
>    - *"Global min"*: `100`
>    - *"Global max"*: `800`
>    - *"number_of_combinations"*: `5`
>    - *"abundance_score_threshold"*: `100`
>    - *"peak_distance_threshold"*: `2`
>    - *"coverage_threshold"*: `80`
>    - *"fill_series"*: `FALSE`
>
>
{: .hands_on}


> <question-title></question-title>
>
> 1. How many series are returned when parameter `fill_series = FALSE` and when `TRUE`?
> 2. I set the `fill_series = TRUE` and only 7 series were returned. How is it possible?
>
> > <solution-title></solution-title>
> >
> > 1. When `fill_series = FALSE`, only number of series corresponding to the number of combinations computed is returned, so in our case 5 series will be returned. If we set `fill_series = TRUE`, series will automatically get filled up to 10 series.
> > 2. The number of series passing all additional thresholds was too low, so 7 unique series were the only one, which got into the selection.
> >
> {: .solution}
>
{: .question}

## Recal

The Recal function is used for the internal mass recalibration. It takes the output from MFAssignCHO and outputs from IsoFiltrR, the Mono and Iso dataframes. Finally, it takes the series for recalibration, either chosen by the user or selected by FindRecalSeries function. 

A very common error points to increasing the MzRange parameter, which sets the recalibration segment length and has a default value of 30 - sometimes it is needed to increase it to even values as 80. Other parameters we can left to their defaults.

> <hands-on-title> Internal mass recalibration </hands-on-title>
>
> 1. {% tool [MFAssignR Recal](toolshed.g2.bx.psu.edu/repos/recetox/mfassignr_recal/mfassignr_recal/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Input data (Output from MFAssign)"*: `Unambig` (output of **MFAssignR MFAssignCHO** {% icon tool %})
>    - {% icon param-file %} *"Calibration series (Output from RecalList)"*: `final_series` (output of **MFAssignR FindRecalSeries** {% icon tool %})
>    - {% icon param-file %} *"Peaks dataframe (Mono from IsoFiltR)"*: `mono_out` (output of **MFAssignR IsoFiltR** {% icon tool %})
>    - {% icon param-file %} *"Isopeaks dataframe (Iso from IsoFiltR)"*: `iso_out` (output of **MFAssignR IsoFiltR** {% icon tool %})
>    - *"Ion mode"*: `negative`
>    - *"SN ratio"*: `6`
>    - *"Estimated noise"*: `346.0`
>    - *"Mass windows used for the segmented recalibration"*: `50.0`
>
>    > <comment-title> short description </comment-title>
>    >
>    > A comment about the tool or something else. This box can also be in the main text
>    {: .comment}
>
{: .hands_on}

# Molecular formula assignment

The last step of the workflow is the actual assignment of molecular formulas with 12C, 1H and 16O and variety of heteroatoms and isotopes, including 2H, 13C, 14N, 15N, 31P, 32S, 34S, 35Cl, 37Cl, 19F, 79Br, 81Br, and 126I. It can also assign Na+ adducts, which are common in positive ion mode.

> <hands-on-title> MF assignment using MFAssign </hands-on-title>
>
> 1. {% tool [MFAssignR MFAssign](toolshed.g2.bx.psu.edu/repos/recetox/mfassignr_mfassign/mfassignr_mfassign/1.1.1+galaxy0) %} with the following parameters:
>    - {% icon param-file %} *"Data frame of monoisotopic masses"*: `Mono` (output of **MFAssignR Recal** {% icon tool %})
>    - {% icon param-file %} *"Data frame of isotopic masses"*: `Iso` (output of **MFAssignR Recal** {% icon tool %})
>    - *"Ion mode"*: `negative`
>    - *"SN ratio"*: `6`
>    - *"Estimated noise"*: `346.0`
>    - *"Lower limit of molecular mass to be assigned"*: `50.0`
>    - *"Upper limit of molecular mass to be assigned"*: `1000.0`
>
{: .hands_on}

Finally, we obtain assigned formulas on rearranged data. Similarly to MFAssignCHO function, dataframes of unassigned masses, ambiguous assignmens and unambigous assignments are provided.


# Conclusion

In this tutorial we showed how we can assign the molecular formulas using MFAssignR package. We learnt that there are several key steps, including noise evaluation, isotope filtering, recalibration and finally the formula assignment. We described how parameters of individual functions are used and how they should be adjusted if needed. 

![workflow overview](images/workflow_overview.png)
