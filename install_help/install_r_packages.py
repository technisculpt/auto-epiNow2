import rpy2.robjects as robjects
import os

lib = 'r_lib'

if not os.path.exists(lib):
    os.mkdir(lib)

depends = [
    "readr",
    ]
    # "data.table",
    # "futile.logger",
    # "future",
    # "future.apply",
    # "ggplot2",
    # "lubridate",
    # "patchwork",
    # "progressr",
    # "purrr",
    # "R.utils", 
    # "Rcpp",
    # "runner",
    # "scales",
    # "truncnorm",
    # "BH",
    # "RcppEigen",
    # "RcppParallel",
    # "StanHeaders",
    # "rstan",
    # "rstantools",
    # "knitr"]


def install():

    #for package in depends:
    #    robjects.r(f'install.packages("{package}", dependencies=TRUE, lib="{lib}", INSTALL_opts = "--no-multiarch")')
    #robjects.r(f'install.packages("EpiNow2", dependencies=TRUE, lib="{lib}", repos = "https:/epiforecasts.r-universe.dev", INSTALL_opts = "--no-multiarch")')
    robjects.r(f'install.packages("EpiNow2", dependencies=TRUE, lib="{lib}", INSTALL_opts = "--no-multiarch")')

install()

