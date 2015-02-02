dmg_properties = node['lyraphase_workstation']['daisydisk']['dmg']
zip_properties = node['lyraphase_workstation']['daisydisk']['zip']

unless dmg_properties.nil? && ! zip_properties.nil?
  dmg_package "DaisyDisk" do
    source      dmg_properties['source']
    checksum    dmg_properties['checksum']
    volumes_dir dmg_properties['volumes_dir']
    owner       node['current_user']
  end
end

unless zip_properties.nil? && ! dmg_properties.nil?
  app_path='/Applications/DaisyDisk.app'

  unless File.exists?(app_path)
    remote_file "#{Chef::Config[:file_cache_path]}/DaisyDisk.zip" do
      source   zip_properties['source']
      checksum zip_properties['checksum']
      mode     '0644'
    end

    execute 'unzip DaisyDisk' do
      command "unzip #{Chef::Config[:file_cache_path]}/DaisyDisk.zip DaisyDisk.app/* -d /Applications/"
      user    node['current_user']
      group   'admin'
    end
  end
end

app_supportdir = "#{node['lyraphase_workstation']['home']}/Library/Application Support"

recursive_directories([app_supportdir, "DaisyDisk"]) do
  owner node['current_user']
end

license_data = Chef::EncryptedDataBagItem.load('lyraphase_workstation', 'daisydisk_license') rescue nil

if license_data.nil? && ! node['lyraphase_workstation']['daisydisk']['license'].nil? && ! node['lyraphase_workstation']['daisydisk']['license']['customer_name'].nil? && ! node['lyraphase_workstation']['daisydisk']['license']['registration_key'].nil?
  license_data = node['lyraphase_workstation']['daisydisk']['license']
end

template File.join(app_supportdir, 'DaisyDisk', 'License.DaisyDisk') do
  source "License.DaisyDisk.erb"
  owner node['current_user']
  variables :license => license_data
  not_if { license_data.nil? }
end
