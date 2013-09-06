dmg_properties = node['lyraphase_workstation']['traktor_audio_2']['dmg']

dmg_package "Traktor Audio 2" do
  source      dmg_properties['source']
  checksum    dmg_properties['checksum']
  volumes_dir dmg_properties['volumes_dir']
  dmg_name    dmg_properties['dmg_name']
  app         dmg_properties['app']
  type        dmg_properties['type']
  owner       node['current_user']
  package_id  dmg_properties['package_id']
  action :install
end
