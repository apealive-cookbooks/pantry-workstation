

# lang package managers to install required packages

home = node['platform_family'] == 'Darwin' ? '/Users' : '/home'

node['workstation']['lang-packages'].each do |lang, packages|
  case lang.split('-')[0]
  when 'python'

    # additional from attributes, system wide
    packages.each do |package|
      pkgspec = package.split(':')
      python_package pkgspec[0] do
        version pkgspec[1] if pkgspec.size > 1
        action :install
      end
    end

    # always system wide
    %w(
      mu-repo
      yolk3k
      virtualenvwrapper
    ).each do |package|
      python_package package
    end

    # virtualnevs to be created
    node['workstation']['users'].each do |user|
      python_virtualenv "#{home}/#{user}/.pyenv/openstack"

      # python_virtualenv "#{home}/#{user}/.pyenv/default"
      # it's now ~/.local/lib/
      #
      # python_virtualenv "#{home}/#{user}/.pyenv/openstack-liberty"
      # python_virtualenv "#{home}/#{user}/.pyenv/openstack-kilo"
      # python_virtualenv "#{home}/#{user}/.pyenv/django"

      # virtualenv packages
      #
      # http://docs.openstack.org/cli-reference/common/cli_install_openstack_command_line_clients.html
      %w(python-openstackclient
         python-novaclient
         python-heatclient
         python-keystoneclient).each do |package|
        python_package package do
          # python 3
          virtualenv "#{home}/#{user}/.pyenv/openstack"
        end
      end
    end

  when 'npm'

    # from nodejs attributes
    include_recipe 'nodejs::npm'
    include_recipe 'nodejs::npm_packages'

    # from workstation cookbook attributes
    packages.each do |package|
      nodejs_npm package
    end

  end
end
