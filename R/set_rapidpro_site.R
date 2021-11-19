# Function to reset the values in the environment: site
set_rapidpro_site = function(site) {
  assign("rapidpro_site", site, envir = pkg.env)
}