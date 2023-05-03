res1 <- read.delim("AXXC-WT_deseq2_LFC.txt",row.names = "gene_symbol")
head(res1)
library(EnhancedVolcano)
EnhancedVolcano(res1,
                lab = rownames(res1),
                x = 'log2FoldChange',
                y = 'padj',
                xlim = c(-3, 3),
                ylim = c(-0.5,80),
                title = 'AXXC vs. WT',
                pCutoff = 10e-2,
                FCcutoff = 2,
                pointSize = 2.0,
                labSize = 3.0)


