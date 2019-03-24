require 'spec_helper'

describe 'lyraphase_workstation::traktor_audio_2' do

  context 'when given DMG attributes' do
    let(:dmg_properties) {
      {
        'source' => 'http://lyraphase.com/doc/installers/mac/Traktor_Audio_2_270_Mac_p.dmg',
        'checksum' => 'e73d7ce1d023297e8081ae72c8cb23539efc18ed7c549df7ef5e19590c72d54e',
        'volumes_dir' => 'Traktor Audio 2',
        'dmg_name' => 'Traktor_Audio_2_270_Mac_p',
        'app' => 'Traktor Audio 2 2.7.0 Installer Mac',
        'type' => 'pkg',
        'package_id' => 'com.caiaq.NIUSBTraktorAudio2Driver_10.9'
      }
    }
    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'

        node.normal['lyraphase_workstation']['traktor_audio_2']['dmg'] = dmg_properties
      end.converge(described_recipe)
    }

    it "installs Traktor Audio 2 DMG" do
      chef_run.converge(described_recipe)
      expect(chef_run).to install_dmg_package(dmg_properties['app'])
    end
  end


## Fauxhai 6.8.0 in ChefDK <??unreleased??>
# Adds support for: 10.14
# Removed support for: 10.10
# Support List:
# 10.11
# 10.12
# 10.13
# 10.14
## Fauxhai 6.6.0 in ChefDK 3.3.23
# 10.10
# 10.11
# 10.12
# 10.13
## Fauxhai 5.5.0 Adds support for:
# 10.13
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
  # This is used as default platforms to test Array until we detect Fauxhai version
  # Note: 10.10 was finally deprecated in Fauxhai 6.8.0, so newer versions don't use this
  platforms_to_test = [
    { platform: 'mac_os_x', version: '10.10',   dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', code_name: 'Yosemite',      disable_app_nap: true }
  ]
  fauxhai_ver = Gem.loaded_specs["fauxhai"].version
  case
    when fauxhai_ver <= Gem::Version.new('7.0.0') && fauxhai_ver >= Gem::Version.new('6.8.0')
      platforms_to_test = []
      # 10.10 DEPRECATED in Fauxhai 6.8.0 ... no more similarity with previous mac_os_x platform sets
      [
        { platform: 'mac_os_x', version: '10.11', dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'El Capitan',    disable_app_nap: true },
        { platform: 'mac_os_x', version: '10.12', dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'Sierra',        disable_app_nap: true },
        { platform: 'mac_os_x', version: '10.13', dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'High Sierra',   disable_app_nap: true },
        { platform: 'mac_os_x', version: '10.14', dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'Mojave',        disable_app_nap: true }
      ].each do |old_platform|
        platforms_to_test.unshift( old_platform )
      end
    when fauxhai_ver < Gem::Version.new('6.8.0') && fauxhai_ver >= Gem::Version.new('6.0.0')
      [
        # 10.10 already in union set above
        { platform: 'mac_os_x', version: '10.11', dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'El Capitan',    disable_app_nap: true },
        { platform: 'mac_os_x', version: '10.12', dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'Sierra',        disable_app_nap: true },
        { platform: 'mac_os_x', version: '10.13', dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', dmg_volumes_dir: 'Traktor Pro 2.6', code_name: 'High Sierra',   disable_app_nap: true }
      ].each do |old_platform|
        platforms_to_test.unshift( old_platform )
      end
    when fauxhai_ver < Gem::Version.new('6.0.0') && fauxhai_ver > Gem::Version.new('5.5.0')
      [
        { platform: 'mac_os_x', version: '10.11', dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', code_name: 'El Capitan',    disable_app_nap: true },
        { platform: 'mac_os_x', version: '10.12', dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', code_name: 'Sierra',        disable_app_nap: true },
        { platform: 'mac_os_x', version: '10.13', dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', code_name: 'High Sierra',   disable_app_nap: true }
      ].each do |old_platform|
        platforms_to_test.unshift( old_platform )
      end
    when fauxhai_ver < Gem::Version.new('5.5.0') && fauxhai_ver > Gem::Version.new('5.0.0')
      [
        { platform: 'mac_os_x', version: '10.11', dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', code_name: 'El Capitan',    disable_app_nap: true },
        { platform: 'mac_os_x', version: '10.12', dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', code_name: 'Sierra',        disable_app_nap: true }
      ].each do |old_platform|
        platforms_to_test.unshift( old_platform )
      end
    when fauxhai_ver < Gem::Version.new('5.0.0') && fauxhai_ver > Gem::Version.new('4.0.0')
      [
        # 10.10 already in union set above
        { platform: 'mac_os_x', version: '10.9.2',  dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', code_name: 'Mavericks',     disable_app_nap: true },
        { platform: 'mac_os_x', version: '10.11.1', dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', code_name: 'El Capitan',    disable_app_nap: true },
        { platform: 'mac_os_x', version: '10.12',   dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', code_name: 'Sierra',        disable_app_nap: true }
      ].each do |old_platform|
        platforms_to_test.unshift( old_platform )
      end

    when fauxhai_ver < Gem::Version.new('4.0.0')
      [
        { platform: 'mac_os_x', version: '10.6.8',  dmg_app: 'Traktor Audio 2 2.7.0 Installer Mac', code_name: 'Snow Leopard',  disable_app_nap: false },
        { platform: 'mac_os_x', version: '10.7.4',  dmg_app: 'Traktor Audio 2 2.7.0 Installer Mac', code_name: 'Lion',          disable_app_nap: false },
        { platform: 'mac_os_x', version: '10.8.2',  dmg_app: 'Traktor Audio 2 2.7.0 Installer Mac', code_name: 'Mountain Lion', disable_app_nap: false }
      ].each do |old_platform|
        platforms_to_test.unshift( old_platform )
      end
  end

  if fauxhai_ver >= Gem::Version.new('3.9.0')
    unless platforms_to_test.select{|x| x[:version] == '10.10'}
      platforms_to_test.push( { platform: 'mac_os_x', version: '10.12', dmg_app: 'Traktor Audio 2 2.8.0 Installer Mac', code_name: 'Sierra', disable_app_nap: true } )
    end
  end

  Chef::Log.warn( "Detected Platforms to Test: " )
  Chef::Log.warn( platforms_to_test )


  platforms_to_test.each do |os|
    context "on #{os[:platform].split('_').map(&:capitalize).join(' ')} #{os[:version]} (#{os[:code_name]})" do
      let(:cf_bundle_id) { 'com.caiaq.driver.NIUSBTraktorAudio2Driver' }
      let(:chef_run) do
        klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
        klass.new(os) do |node|
          # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
          create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
          node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
          node.normal['lyraphase_workstation']['user'] = 'brubble'
        end.converge(described_recipe)
      end

      it "installs DMG #{os[:dmg_app]}" do
        chef_run.converge(described_recipe)
        expect(chef_run).to install_dmg_package(os[:dmg_app])
      end

      if os[:disable_app_nap]
        it "disables app nap" do
          # Chef::Log.warn("METHOD: #{self.method(:write_osx_defaults)}")
          # Chef::Log.warn("ARITY: #{self.method(:write_osx_defaults).arity}")
          # Workaround a very weird problem with ChefSpec Matcher arity being different on Chef 13 vs 11 & 12
          if self.method(:write_osx_defaults).arity == 1
            expect(chef_run).to write_osx_defaults("Disable App Nap for #{cf_bundle_id}").with(domain: cf_bundle_id, key: 'NSAppSleepDisabled', boolean: true)
          elsif self.method(:write_osx_defaults).arity == 2
            expect(chef_run).to write_osx_defaults(cf_bundle_id, 'NSAppSleepDisabled').with(boolean: true)
          end
        end
      end
    end
  end
end
