
include_recipe "pantry::default"
include_recipe "#{cookbook_name}::users"
include_recipe "#{cookbook_name}::homeshick"
include_recipe "#{cookbook_name}::lang-packages"
include_recipe "#{cookbook_name}::extr-packages"
