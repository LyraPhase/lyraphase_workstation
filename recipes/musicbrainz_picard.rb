dmg_properties = node['lyraphase_workstation']['musicbrainz_picard']['dmg']

dmg_package "MusicBrainz Picard" do
  source      dmg_properties['source']
  checksum    dmg_properties['checksum']
  owner       node['current_user']
  type 'app'
  #package_id  'com.native-instruments.Traktor2.*'
end