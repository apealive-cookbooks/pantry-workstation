

include_recipe 'users'

# Generic users (from databag)
users_manage 'users' do
  action :create
end
