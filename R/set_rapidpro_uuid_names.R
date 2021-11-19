# Set the rapidpro uuid names. By default, the flow names. This function is usually called in another function
set_rapidpro_uuid_names = function(uuid_names = get_flow_names()){#[c("uuid", "name")]) {
  assign("rapidpro_uuid_names", uuid_names, envir = pkg.env)
}