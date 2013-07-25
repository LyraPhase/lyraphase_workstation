dmg_properties = node['lyraphase_workstation']['omnifocus']['dmg']

dmg_package "OmniFocus" do
  source      dmg_properties['source']
  checksum    dmg_properties['checksum']
  owner       node['current_user']
  type 'app'
  accept_eula true
  #package_id  'com.native-instruments.Traktor2.*'
end
