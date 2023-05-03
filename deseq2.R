## Deseq2 for DGE ##
cts <- as.matrix(read.delim("sum_rawcount_wt-axxc.txt", sep="\t", row.names="gene_name"))
head(cts)
coldata <- read.delim("coldata_AXXC-WT.txt")
coldata
coldata$condition <- factor(coldata$condition)

library(DESeq2)
dds <- DESeqDataSetFromMatrix(countData = cts,
                              colData = coldata,
                              design= ~condition)
dds
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]

dds$condition <- relevel(dds$condition, ref="WT")

dds <- DESeq(dds)
resultsNames(dds) # Lists the coefficients
res1 <- results(dds, name="condition_AXXC_vs_WT")
summary(res1)
write.csv(res1, file="AXXC-WT_deseq2.csv")
plotMA(res1,ylim=c(-7,7))

normcount <- counts(dds, normalized=T)
write.csv(normcount, file="AXXC-WT_deseq2_normcount.csv")


res2 <- lfcShrink(dds, coef="condition_AXXC_vs_WT", type="apeglm")
write.csv(res2, file="AXXC-WT_deseq2_LFC.csv")
