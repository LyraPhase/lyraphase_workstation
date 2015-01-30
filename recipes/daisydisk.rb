dmg_properties = node['lyraphase_workstation']['daisydisk']['dmg']

dmg_package "DaisyDisk" do
  source      dmg_properties['source']
  checksum    dmg_properties['checksum']
  volumes_dir dmg_properties['volumes_dir']
  owner       node['current_user']
end

app_supportdir = "#{node['lyraphase_workstation']['home']}/Library/Application Support"

recursive_directories([app_supportdir, "DaisyDisk"]) do
  owner node['current_user']
end

license_data = Chef::EncryptedDataBagItem.load('lyraphase_workstation', 'daisydisk_license') rescue nil

unless license_data.nil? && ! node['lyraphase_workstation']['daisydisk']['license'].nil? && ! node['lyraphase_workstation']['daisydisk']['license']['customer_name'].nil? && ! node['lyraphase_workstation']['daisydisk']['license']['registration_key'].nil?
  license_data = node['lyraphase_workstation']['daisydisk']['license']
end

template File.join(app_supportdir, 'DaisyDisk', 'License.DaisyDisk') do
  source "License.DaisyDisk.erb"
  owner node['current_user']
  variables :license => license_data
  not_if { license_data.nil? }
end
