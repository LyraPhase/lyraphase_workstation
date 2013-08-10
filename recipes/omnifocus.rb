dmg_properties = node['lyraphase_workstation']['omnifocus']['dmg']

dmg_package "OmniFocus" do
  source      dmg_properties['source']
  checksum    dmg_properties['checksum']
  owner       node['current_user']
  type 'app'
  accept_eula true
  #package_id  'com.native-instruments.Traktor2.*'
end

# TODO: Install license, remove sprout attribute dependency
# app_supportdir = "#{node['sprout']['home']}/Library/Application Support"

# recursive_directories([app_supportdir, "Omni Group", "Software Licenses/"]) do
#   owner node['current_user']
# end

# template File.join(app_supportdir, 'DaisyDisk', 'License.DaisyDisk') do
#   source "License.DaisyDisk.erb"
#   owner node['current_user']
#   variables :license => node['lyraphase_workstation']['omnifocus']['license']
#   not_if { node['lyraphase_workstation']['omnifocus']['license']['owner'].nil? || node['lyraphase_workstation']['omnifocus']['license']['key'].nil? }
# end
