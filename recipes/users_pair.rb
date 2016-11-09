#
# Cookbook Name:: pantry-workstation
# Recipe:: users_pair
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

package 'tmux'

user 'pair' do
  comment 'A pair-programming user'
  home '/home/pair'
  shell '/bin/bash'
  #password '$1$JJsvHslasdfjVEroftprNn4JHtDi'
  manage_home true
  action [ :create, :manage ]
end


# add pantry users to pair group (so they may clone/share in pair /home)
#user 'pmichalec' do
  #groups ['pair']
  #action [:manage]
#end

# generate root ssh keys
ssh_dir = ::File.join('/home/pair/.ssh')
directory ssh_dir do
  owner 'pair'
  group 'pair'
  mode 0750
  subscribes :create, 'user[pair]'
  notifies :run, 'bash[generate pair user ssh keys]'
  not_if { ! ::File.exist?('/home/pair') }
end

bash 'generate pair user ssh keys' do
  cwd ssh_dir
  code <<-EOF
        ssh-keygen -t rsa -N "" -q -C "pair@#{node['fqdn']}" -f id_rsa_pair
        echo -n 'command="/usr/local/bin/tmux attach -t pair" ' > /home/pair/.ssh/authorized_keys
        cat id_rsa_pair.pub                                    >>/home/pair/.ssh/authorized_keys
        chmod og-rwx  #{ssh_dir}
        chown -R root #{ssh_dir}
        chgrp -R root #{ssh_dir}
        chmod -R 400  #{ssh_dir}/*
     EOF
  action :run
  not_if { ::File.exist?(::File.join(ssh_dir, 'id_rsa_pair')) }
  not_if { ! ::File.exist?('/home/pair') }
end


#file '/home/pair/.ssh/authorized_keys' do
  #content <<-EOF pub_key = File.read("/home/pair/.ssh/id_rsa_pair.pub") if File.exist?("/home/pair/.ssh/id_rsa_pair.pub")
    #command="/usr/local/bin/tmux attach -t pair" #{pub_key}
    #EOF
  #owner 'pair'
  #group 'pair'
  #mode 0750
  #not_if { ! ::File.exist?('/home/pair/.ssh') }
#end



