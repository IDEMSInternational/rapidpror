# Rapidreadr

Reading in data from RapidPro API

TODO:
* Add in error messages to the functions
* Determine which (if any) functions do not need to be present
* Check if need to add `...` in any functions
* Work out pkg environment changes. For now run the following before using the functions:

```
library(Rapidreadr)
pkg_env <- new.env(parent = emptyenv())
assign("rapidpro_key", NULL, envir = pkg_env)
assign("rapidpro_site", NULL, envir = pkg_env)
```

* Continue reading book and work through
* Package name?
