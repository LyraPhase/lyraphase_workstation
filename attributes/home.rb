include_attribute 'lyraphase_workstation::user'

node.default[:lyraphase_workstation][:home] =  node[:etc][:passwd][node[:sprout][:user]][:dir]
