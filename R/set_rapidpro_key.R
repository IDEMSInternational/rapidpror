# Function to reset the values in the environment: key
set_rapidpro_key = function(key) {
  assign("rapidpro_key", key, envir = pkg.env)
}