% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tab_dimensionreduction.R
\name{explVar}
\alias{explVar}
\title{Retrieve the explained variance for each principal component (PCA) or
axis (PCoA)}
\usage{
explVar(x, params, type = c("PCA", "PCoA"))
}
\arguments{
\item{x}{`matrix`, containing no missing values (`NA`), samples in columns
and features in rows}

\item{params}{`list`, containing the parameters for PCA and PCoA. For 
`type = "PCA"` these are `center` of type `logical` 
(indicating whether the variables should be shifted to be zero centered) and
`scale` of type `logical`(indicating whether the variables should be scaled
that they have a standard variation of 1). For `type = "PCoA"`, this 
is `method` of type `character` (indicating the method for distance 
calculation).}

\item{type}{`character`, one of `"PCA"` or `"PCoA"`}
}
\value{
`numeric` vector with the proportion of explained variance for each 
PC or Axis
}
\description{
The function `explVar` calculates the proportion of explained variance for
each principal component (PC, `type = "PCA"`) and axis (`type = "PCoA"`).
}
\details{
`explVar` uses the function `prcomp` from the `stats` package to retrieve
the explained standard deviation per PC (`type = "PCA"`) and the function 
`cmdscale` from the `stats` package to retrieve the explained variation 
based on eigenvalues per Axis (`type = "PCoA"`).
}
\examples{
x <- matrix(1:100, nrow = 10, ncol = 10, 
    dimnames = list(1:10, paste("sample", 1:10)))
set.seed(1)
x <- x + rnorm(100)
explVar(x = x, params = list(center = TRUE, scale = TRUE), type = "PCA")
explVar(x = x, params = list(method = "euclidean"), type = "PCoA")

}
\author{
Thomas Naake
}
