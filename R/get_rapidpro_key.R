# Function to get the values in the environment: key
get_rapidpro_key = function() {
  get("rapidpro_key", envir = pkg.env)
}