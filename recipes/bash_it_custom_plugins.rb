include_recipe 'sprout-base::bash_it'

node[:lyraphase_workstation][:bash_it][:custom_plugins].each do |custom_plugin|
  sprout_base_bash_it_custom_plugin custom_plugin
end
