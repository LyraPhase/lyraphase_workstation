include_attribute 'lyraphase_workstation::home'

node.default[:lyraphase_workstation] = {
  :bash_it => {
    :custom_plugins => %w[
      bash_it/custom/git-custom_subdir_gitconfig.aliases.bash
      bash_it/custom/less-manpage-colors.bash
    ]
  }
}
