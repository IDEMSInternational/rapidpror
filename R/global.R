utils::globalVariables(c("pkg_env", "responded", "created_on", "flow_data", "start_date", "archive_type"))
pkg_env <- new.env(parent = emptyenv())
pkg_env$rapidpro_key <- NULL
pkg_env$rapidpro_site <- NULL
pkg_env$rapidpro_uuid_names <- NULL 