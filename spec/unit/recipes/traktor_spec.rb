require 'spec_helper'

describe 'lyraphase_workstation::traktor' do

  context 'when given DMG attributes' do
    let(:dmg_properties) {
      {
        'source' => 'http://www.lyraphase.com/doc/installers/mac/TraktorPro26.dmg',
        'checksum' => 'c840fa5fa58cad2a7eec44049c3908b7059575d3103a7e5fe6de14829b489066',
        'volumes_dir' => 'Traktor Pro 2.6',
        'dmg_name' => 'TraktorPro26',
        'app' => 'Traktor 2 2.6.0 Mac',
        'type' => 'mpkg'
      }
    }
    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'

        node.normal['lyraphase_workstation']['traktor']['dmg'] = dmg_properties
      end.converge(described_recipe)
    }

    it "installs Traktor Pro 2.6 DMG" do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package(dmg_properties['volumes_dir'])
    end
  end

## Fauxhai 5.3.0 in ChefDK  2.3.1 only supports the following mac_os_x versions:
# 10.10
# 10.11
# 10.12
# 10.13
## Fauxhai 4.1.0 in ChefDK 1.3.43 only supports the following mac_os_x versions:
# 10.10
# 10.11.1
# 10.9.2
# 10.12
## Older Fauxhai  & ChefDK <= 1.2.22 supports older versions:
# 10.6.8
# 10.7.4
# 10.8.2
# 10.9.2
# 10.10
# 10.11.1
# Versions: 10.6.8, 10.7.4, 10.8.2 were removed in customink/fauxhai@19296a8ba49c2265d491847653152bad3f02b392
# which was released as fauxhai v4.0.0
# Old install: 
## export DEBIAN_FRONTEND=noninteractive ;  curl -sSL "https://downloads.chef.io/packages-chef-io-public.key" | apt-key add -
## echo "deb https://packages.chef.io/stable-apt precise main" | sudo tee -a /etc/apt/sources.list > /dev/null
## apt-get -yq --no-install-suggests --no-install-recommends --force-yes install chefdk=1.2.22-1

  Chef::Log.warn( "Fauxhai version: " )
  Chef::Log.warn( Gem.loaded_specs["fauxhai"].version )
  Chef::Log.warn( "Is Fauxhai >= 4.0: " )
  Chef::Log.warn( Gem.loaded_specs["fauxhai"].version >= Gem::Version.new('4.0.0') )
  Chef::Log.warn( "Is Fauxhai >= 5.0: " )
  Chef::Log.warn( Gem.loaded_specs["fauxhai"].version >= Gem::Version.new('5.0.0') )
  Chef::Log.warn( "Is Fauxhai < 6.0: " )
  Chef::Log.warn( Gem.loaded_specs["fauxhai"].version < Gem::Version.new('6.0.0') )

  # Intersection of all version sets (old_platforms & new_platforms & fauxhai_5_platforms)
  platforms_to_test = [
    { platform: 'mac_os_x', version: '10.10',   dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'Yosemite',      disable_app_nap: true }
  ]

  if Gem.loaded_specs["fauxhai"].version < Gem::Version.new('6.0.0')
    [
      { platform: 'mac_os_x', version: '10.11',   dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'El Capitan',    disable_app_nap: true },
      { platform: 'mac_os_x', version: '10.12',   dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'Sierra',        disable_app_nap: true },
      { platform: 'mac_os_x', version: '10.13',   dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'High Sierra',   disable_app_nap: true }
    ].each do |old_platform|
      platforms_to_test.unshift( old_platform )
    end
  end

  if Gem.loaded_specs["fauxhai"].version < Gem::Version.new('5.0.0')
    [
      { platform: 'mac_os_x', version: '10.9.2',  dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'Mavericks',     disable_app_nap: true },
      { platform: 'mac_os_x', version: '10.11.1', dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'El Capitan',    disable_app_nap: true }
    ].each do |old_platform|
      platforms_to_test.unshift( old_platform )
    end
  end

  if Gem.loaded_specs["fauxhai"].version < Gem::Version.new('4.0.0')
    [
      { platform: 'mac_os_x', version: '10.6.8',  dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'Snow Leopard',  disable_app_nap: false },
      { platform: 'mac_os_x', version: '10.7.4',  dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'Lion',          disable_app_nap: false },
      { platform: 'mac_os_x', version: '10.8.2',  dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'Mountain Lion', disable_app_nap: false }
    ].each do |old_platform|
      platforms_to_test.unshift( old_platform )
    end
  end

  if Gem.loaded_specs["fauxhai"].version >= Gem::Version.new('3.9.0')
    platforms_to_test.push( { platform: 'mac_os_x', version: '10.12',  dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'Sierra', disable_app_nap: true } )
  end


  platforms_to_test.each do |os|
    context "on #{os[:platform].split('_').map(&:capitalize).join(' ')} #{os[:version]} (#{os[:code_name]})" do
      let(:cf_bundle_id) { 'com.native-instruments.Traktor2.Application' }
      let(:chef_run) do
        klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
        klass.new(os) do |node|
          # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
          create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
          node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
          node.normal['lyraphase_workstation']['user'] = 'brubble'
        end.converge(described_recipe)
      end

      it "installs DMG #{os[:dmg_volumes_dir]}" do
        chef_run.converge(described_recipe)
        expect(chef_run).to install_dmg_package(os[:dmg_volumes_dir])
      end

      if os[:disable_app_nap]
        it "disables app nap" do
          expect(chef_run).to write_osx_defaults(cf_bundle_id, 'NSAppSleepDisabled').with_boolean(true)
        end
      end
    end
  end
end
