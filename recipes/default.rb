
include_recipe "pantry::default"

include_recipe "#{cookbook_name}::users"
include_recipe "#{cookbook_name}::lang-packages"

case node['platform_family']
when 'debian', 'rhel'
  include_recipe "#{cookbook_name}::homeshick"
  include_recipe "#{cookbook_name}::extr-packages"
when 'mac_os_x'
  include_recipe "#{cookbook_name}::homeshick"
  # TODO osx handler
when 'windows'
  # TODO windows handler
end
