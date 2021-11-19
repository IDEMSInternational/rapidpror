# Get the rapidpro names. This function is usually called in another function
get_rapidpro_uuid_names = function(){
  get("rapidpro_uuid_names", envir = pkg.env)
}