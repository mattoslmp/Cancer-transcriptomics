# download the BioC installation routines
source("http://bioconductor.org/biocLite.R")

# install the required packages
list_of_packages <- c(
  "GEOquery", "frma", "affy", "cluster", "impute", "preprocessCore",
  "WGCNA", "simpleaffy", "RColorBrewer", "devtools", "ggfortify", 
  "ggplot2", "sva", "limma", "hgu133plus2.db"
)

# Install Bioconductor packages
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}
BiocManager::install(list_of_packages)

# Load required libraries
library(GEOquery)
library(frma)
library(affy)
library(cluster)
library(impute)
library(preprocessCore)
library(WGCNA)
library(simpleaffy)
library(RColorBrewer)
library(devtools)
library(ggfortify)
library(ggplot2)
library(sva)
library(limma)
library(hgu133plus2.db)

# Set the working directory
setwd("/home/mattoslmp/datasets_arrays/SampleNetworkFiles")

# Read CEL files and phenodata
celfiles <- read.affy(covdesc = "phenodata.txt", path = "/home/mattoslmp/datasets_arrays/data")
phenodata <- read.table("/home/mattoslmp/datasets_arrays/data/phenodata.txt", head = TRUE)
phenodata <- phenodata[, 1:3]
phenodata <- data.frame(phenodata)
rownames(phenodata) <- phenodata$FileName

# Perform FRMA normalization
celfiles.frma <- frma(celfiles, background = "rma", normalize = "quantile",
                     summarize = "robust_weighted_average", target = "probeset",
                     input.vecs = NULL, output.param = NULL, verbose = FALSE)

# Extract expression data and phenodata
edata <- exprs(celfiles.frma)
batch <- phenodata$Batch
condition <- as.factor(phenodata$Target)
sample <- phenodata$sample

# Create the design matrix
pdata <- data.frame(sample, batch, condition)
modmatrix <- model.matrix(~ as.factor(condition), data = pdata)

# Perform batch effect correction using ComBat
combat_edata <- ComBat(dat = edata, batch = batch, mod = modmatrix,
                       par.prior = TRUE, prior.plots = TRUE)

# Create an ExpressionSet object with ComBat-corrected data and phenodata
celfiles.frma.combateset <- ExpressionSet(combat_edata,
                                          phenoData = AnnotatedDataFrame(phenodata),
                                          annotation = "hgu133plus2.db")

# Perform differential expression analysis
# Set up the experimental design
samples <- celfiles.frma.combateset$Target
design <- model.matrix(~ 0 + samples)
colnames(design) <- make.names(unique(samples))

# Fit the linear model
fit <- lmFit(exprs(celfiles.frma.combateset), design)

# Perform empirical Bayes statistics
cellline_fits <- eBayes(contrasts.fit(fit, design))
top30 <- topTable(cellline_fits, coef = 1, number = 30, sort.by = "B")

# Perform venn diagram analysis
results <- decideTests(cellline_fits, p.value = 0.01, lfc = 2, method = "separate")
vennDiagram(results[, c(1, 2, 3, 4)], include = c("up", "down"), counts.col = c("red", "green"))
vennCounts(results[, c(1, 2, 3, 4)])

# Print the number of genes in the filtered list
filtered_genes <- topTable(cellline_fits, coef = 1, adjust = "fdr", sort.by = "P", number = 50000)
filtered_genes <- filtered_genes[filtered_genes$adj.P.Val < 0.01 & (filtered_genes$logFC > 2 | filtered_genes$logFC < -2) & filtered_genes$AveExpr > 10, ]
print("Number of genes in this list:")
length(rownames(filtered_genes))

# Plot heat diagram
heatDiagram(results, cellline_fits$coef, primary = 1)
results[results[, 1] == 1, ]
