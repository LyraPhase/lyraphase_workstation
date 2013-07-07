dmg_package "Traktor Pro 2.6" do
  source "http://www.lyraphase.com/doc/installers/mac/TraktorPro26.dmg"
  checksum "c840fa5fa58cad2a7eec44049c3908b7059575d3103a7e5fe6de14829b489066"
  action :install
  volumes_dir "Traktor Pro 2.6"
  dmg_name 'TraktorPro26'
  app 'Traktor 2 2.6.0 Mac'
  type "mpkg"
  owner node['current_user']
  package_id 'com.native-instruments.Traktor2.*'
end