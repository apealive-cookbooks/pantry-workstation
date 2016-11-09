#
# Cookbook Name:: pantry-workstation
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# include_recipe "homeshick"

home = node['platform_family'] == 'Darwin' ? '/Users' : '/home'
node['pantry-workstation']['users'].each do |user|
  user_home = File.join(home, user)

  homeshick user do
    keys node['pantry-workstation']['homeshick_repos']
    group user
    home user_home
    # FIXME: update is asking for ssh key passphrases interactively
    not_if { File.exist?("#{user_home}/.homesick/repos") }
  end

  # TODO: rewrite to Chef DSL
  execute 'boostrap shell' do
    command <<-EOF
      # fish & oh-my-fish
      #curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/bin/install | fish

      # zsh & zsh powerline theme
      homeshick clone --batch robbyrussell/oh-my-zsh
      homeshick clone --batch https://github.com/jeremyFreeAgent/oh-my-zsh-powerline-theme.git
      homeshick clone --batch https://github.com/seebi/dircolors-solarized

      #homeshick link dotshell
      ln -s $HOME/.homesick/repos/oh-my-zsh-powerline-theme/powerline.zsh-theme $HOME/.oh-my-zsh/themes/
      ln -s $HOME/.homesick/repos/dircolors-solarized/dircolors.256dark $HOME/.dircolors
      ln -s $HOME/.homesick/repos/dircolors-solarized/dircolors.256dark $HOME/.dir_colors


      mkdir -p $HOME/.local/share/fonts #FIXME: see/run fonts/install.sh
      ln -s $HOME/.homeshick/repos/fonts $HOME/.local/share/fonts

      # set default shell
      #which fish && chsh -s $(which fish)
      which zsh && chsh -s $(which zsh)


      # install z
      wget https://raw.githubusercontent.com/rupa/z/master/z.sh -O ~/bin/z.sh
      chmod u+x ~/bin/z.sh

    EOF
    user user
    group user
  end
end
