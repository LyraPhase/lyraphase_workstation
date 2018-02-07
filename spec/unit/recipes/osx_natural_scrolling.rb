require 'spec_helper'

describe 'lyraphase_workstation::osx_natural_scrolling' do

  context 'when given node["lyraphase_workstation"]["settings"]["natural_scrolling"] = true' do
    let(:global_domain) { '/Users/brubble/Library/Preferences/.GlobalPreferences' }

    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'

        node.normal['lyraphase_workstation']['settings']['natural_scrolling'] = true
      end.converge(described_recipe)
    }

    it 'sets OSX natural scrolling direction via com.apple.swipescrolldirection' do
      expect(chef_run).to write_osx_defaults(global_domain, 'com.apple.swipescrolldirection').with(boolean: true)
    end
  end

  context 'when given node["lyraphase_workstation"]["settings"]["natural_scrolling"] = false' do
    let(:global_domain) { '/Users/brubble/Library/Preferences/.GlobalPreferences' }

    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'

        node.normal['lyraphase_workstation']['settings']['natural_scrolling'] = false
      end.converge(described_recipe)
    }

    it 'sets OSX natural scrolling direction via com.apple.swipescrolldirection' do
      expect(chef_run).to write_osx_defaults(global_domain, 'com.apple.swipescrolldirection').with(boolean: false)
    end
  end

end
