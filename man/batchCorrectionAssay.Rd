% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tab_values.R
\name{batchCorrectionAssay}
\alias{batchCorrectionAssay}
\title{Remove batch effects from (count/intensity) values of a 
`SummarizedExperiment`}
\usage{
batchCorrectionAssay(
  se,
  method = c("none", "removeBatchEffect (limma)"),
  batchColumn = colnames(colData(se))
)
}
\arguments{
\item{se}{`SummarizedExperiment`}

\item{method}{`character`, one of `"none"` or `"removeBatchEffect"`}

\item{batchColumn}{`character`, one of `colnames(colData(se))`}
}
\value{
`matrix`
}
\description{
The function `batchCorrectionAssay` removes the batch effect of 
(count/intensity) values of a `SummarizedExperiment`. 
It uses either the `removeBatchEffect` function 
or no batch effect correction method (pass-through, 
`none`).
}
\details{
The column `batchColumn` in `colData(se)` contains the information on the 
batch identity. Internal use in `shinyQC`.
}
\examples{
## create se
a <- matrix(1:100, nrow = 10, ncol = 10, 
            dimnames = list(1:10, paste("sample", 1:10)))
a[c(1, 5, 8), 1:5] <- NA
set.seed(1)
a <- a + rnorm(100)
cD <- data.frame(name = colnames(a), 
    type = c(rep("1", 5), rep("2", 5)), batch = rep(c(1, 2), 5))
rD <- data.frame(spectra = rownames(a))
se <- SummarizedExperiment::SummarizedExperiment(assay = a, 
    rowData = rD, colData = cD)

batchCorrectionAssay(se, method = "removeBatchEffect (limma)", 
                            batchColumn = "batch")

}
