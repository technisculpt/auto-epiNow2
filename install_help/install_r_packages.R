lib = 'r_lib'

local({r <- getOption("repos")
      r["CRAN"] <- "https://cran.csiro.au/"
      options(repos=r)})

list_data <- list("readr","data.table","futile.logger","future","future.apply","ggplot2","lubridate",
"patchwork","progressr","purrr","R.utils", "Rcpp","runner","scales","truncnorm","BH","RcppEigen",
"RcppParallel","StanHeaders","rstan","rstantools","knitr")

# install.packages("EpiNow2", repos = "https:/epiforecasts.r-universe.dev", dependencies=TRUE, lib=lib, INSTALL_opts = "--no-multiarch")

for (val in list_data)
{
    install.packages(val, dependencies=TRUE, lib=lib, INSTALL_opts = "--no-multiarch")
}

