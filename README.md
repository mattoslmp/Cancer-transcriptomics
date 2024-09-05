## Code author: Leandro de Mattos Pereira

## Overview of the Code
- This script performs a comprehensive analysis of gene expression data, including normalization, batch effect removal, differential expression analysis, and co-expression network analysis using WGCNA (Weighted Gene Co-expression Network Analysis). The key steps in the code are as follows:

Reading and Preprocessing Data:

## The script reads in gene expression data from CEL files using the affy package.

- Data is normalized using the FRMA (Frozen Robust Multi-array Analysis) method to ensure consistency across samples.
Initial boxplots and histograms are generated to visualize the raw data before normalization.
Batch Effect Removal:

## To adjust for unwanted variations across batches, the ComBat algorithm from the sva package is used.

- After batch effect removal, clustering is applied to assess the impact of this correction, with plots generated to visualize the changes.
Differential Expression Analysis:

## The normalized and batch-corrected data is analyzed for differential gene expression using the limma package.
- Contrasts are defined to compare specific conditions, and the linear model fit is calculated.
A list of differentially expressed genes is generated and saved, based on a fold-change threshold and adjusted p-value for statistical significance.
Co-expression Network Analysis (WGCNA):

## The script constructs a weighted gene co-expression network using the WGCNA package.

- An optimal soft-thresholding power is chosen to ensure a scale-free topology in the network.
- Genes are clustered into modules based on their expression profiles, and the relationships between modules and experimental conditions are explored.
- Heatmaps of module-condition correlations are produced, and the results of the WGCNA are saved for further analysis.
  Visualizations:

## Various plots (e.g., dendrograms, heatmaps, histograms, and boxplots) are generated throughout the analysis to provide visual insights into the data at each stage of processing.


## Cancer-transcriptomics
## Array Data Analysis

This repository contains scripts for analyzing array data using various R packages and Bioconductor tools. The analysis includes preprocessing steps such as background correction, normalization, batch effect removal, and differential expression analysis.

## Getting Started
## Installation:
To run the analysis, you need to install the following Bioconductor packages: frma, affy, cluster, impute, preprocessCore, WGCNA, GEOquery, simpleaffy, RColorBrewer, devtools, ggfortify, ggplot2, sva, limma, and hgu133plus2.db. You can install these packages using the following command:

biocLite(c("affy", "affy", "cluster", "impute", "preprocessCore", "GEOquery", "WGCNA", "GEOquery", "simpleaffy", "RColorBrewer", "devtools", "ggfortify", "ggplot2", "sva", "limma", "hgu133plus2.db"))


## Step 1: Download the dataset from Gene Expression Omnibus (GEO)
This step involves downloading the gene expression dataset from the Gene Expression Omnibus (GEO) database. GEO stores curated gene expression DataSets that can be used for analysis.

## Step 2: Preprocessing
In this step, the dataset undergoes various preprocessing steps, including normalization, batch effect removal, and quality control. The Bioconductor packages and tools mentioned earlier are used for these processes.

## Step 3: Differential Expression Analysis
After preprocessing, the dataset is ready for differential expression analysis. The analysis compares gene expression between different samples to identify genes that are differentially expressed. Bioconductor packages such as limma are used for this analysis.

## Step 4: Results Visualization
This step involves generating graphical results to visualize the findings from the differential expression analysis. Packages like ggplot2 and RColorBrewer are utilized for creating plots and visualizations.

README: Under Construction
Please note that this README is currently under construction. More detailed instructions and explanations will be added soon.
