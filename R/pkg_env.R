pkg_env <- new.env(parent = emptyenv())
assign("rapidpro_key", NULL, envir = pkg_env)
assign("rapidpro_site", NULL, envir = pkg_env)

# From the book:
# "Don’t use assign() to modify objects in the global environment.
# If you need to maintain state across function calls, create your own environment with
# e <- new.env(parent = emptyenv())
# and set and get values in it:

# e <- new.env(parent = emptyenv())
# 
# add_up <- function(x) {
#   if (is.null(e$last_x)) {
#     old <- 0
#   } else {
#     old <- e$last_x
#   }
#   
#   new <- old + x
#   e$last_x <- new
#   new
# }