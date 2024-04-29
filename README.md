
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rapidpror <img src='man/figures/rapidpror.png' align="right" height="139"/>

<!-- badges: start -->

[![R-CMD-check](https://github.com/IDEMSInternational/rapidpror/workflows/R-CMD-check/badge.svg)](https://github.com/IDEMSInternational/rapidpror/actions)
[![Codecov test
coverage](https://codecov.io/gh/IDEMSInternational/rapidpror/branch/main/graph/badge.svg)](https://app.codecov.io/gh/IDEMSInternational/rapidpror?branch=main)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Project Status: Initial development is in progress, but there has not
yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![license](https://img.shields.io/badge/license-LGPL%20(%3E=%203)-lightgrey.svg)](https://www.gnu.org/licenses/lgpl-3.0.en.html)
<!-- badges: end -->

Reading in data from RapidPro API into R.

## Overview

rapidpror is a package in R to import chatbot data from RapidPro into R.

## Installation

You can install the development version of rapidpror from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("IDEMSInternational/rapidpror")
```

## Functions in rapidpror

rapidpror is a package in R to import data from RapidPro into R for
analysis. This section outlines the functions used to import into R.
These functions are divided into three parts: Identifying Information,
Flow and User Data, and Archived Data.

### Identifying Information:

In RapidPro, each website is associated with a unique token or “key.” To
simplify data retrieval and avoid repetitive key entry, we’ve designed
the following functions to be defined in the package environment:

- `set_rapidpro_key()` sets the rapidpro key.
- `set_rapidpro_site()` sets the rapidpro website.

Once the key and site are defined, you can use the corresponding `get`
functions to access them from other `rapidpror` functions effortlessly:

- `get_rapidpro_key()` gets the rapidpro key.
- `get_rapidpro_site()` gets the rapidpro website.

### Flow Data and User Data:

In this package, we retrive two types of data from RapidPro: user data
and flow data. Each type requires its own functions due to unique
characteristics:

- `get_data_from_rapidpro_api()` A general function that automatically
  fetches the key and site from the package environment, along with
  other specified parameters, such as dates for filtering. An essential
  feature is the `call_type` parameter, which determines the type of
  data to download. This function provides flexibility for various call
  types that users may have.
- `get_user_data()` A wrapper of `get_data_from_rapidpro_api()`, this
  function retrieves user data with the relevant `call_type`, such as
  `"contacts.json?group=joined"`.
- `get_flow_data()` A wrapper of `get_data_from_rapidpro_api()`, this
  function fetches data from a specific flow (or “run”) using
  `call_type = "runs.json?flow="`.
- `get_flow_names()` This function gets the names of different flows

### Archived Data:

Data in RapidPro gets archived after a specific period. To access
archived data, we provide the following functions:

- `get_archived_data()` Allows retrieval of archived data.
- `update_archived_data()` Resaves the archived data with newer data,
  saving time and computing power during retrieval.

## Usage

We aim to add some examples here in using the functions in `rapidpror`.
