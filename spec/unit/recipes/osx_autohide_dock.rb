require 'spec_helper'

describe 'lyraphase_workstation::osx_natural_scrolling' do

  context 'when given node["lyraphase_workstation"]["settings"]["autohide_dock"] = true' do
    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'

        node.normal['lyraphase_workstation']['settings']['autohide_dock'] = true
      end.converge(described_recipe)
    }

    it 'enables AutoHide for OSX Dock via com.apple.dock' do
      chef_run.converge(described_recipe)
      # Workaround a very weird problem with ChefSpec Matcher arity being different on Chef 13 vs 11 & 12
      if self.method(:write_osx_defaults).arity == 1
        expect(chef_run).to write_osx_defaults('Enable AutoHide OSX Dock').with(domain: 'com.apple.dock', key: 'autohide', boolean: true)
      elsif self.method(:write_osx_defaults).arity == 2
        expect(chef_run).to write_osx_defaults('com.apple.dock', 'autohide').with(boolean: true)
      end
    end
  end

  context 'when given node["lyraphase_workstation"]["settings"]["autohide_dock"] = false' do
    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'

        node.normal['lyraphase_workstation']['settings']['autohide_dock'] = false
      end.converge(described_recipe)
    }

    it 'disables AutoHide for OSX Dock via com.apple.dock' do
      chef_run.converge(described_recipe)
      # Workaround a very weird problem with ChefSpec Matcher arity being different on Chef 13 vs 11 & 12
      if self.method(:write_osx_defaults).arity == 1
        expect(chef_run).to write_osx_defaults('Enable AutoHide OSX Dock').with(domain: 'com.apple.dock', key: 'autohide', boolean: false)
      elsif self.method(:write_osx_defaults).arity == 2
        expect(chef_run).to write_osx_defaults('com.apple.dock', 'autohide').with(boolean: false)
      end
    end
  end

  context 'when given node["lyraphase_workstation"]["settings"]["autohide_delay"] = 1.05' do
    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'

        node.normal['lyraphase_workstation']['settings']['autohide_dock'] = 1.05
      end.converge(described_recipe)
    }

    it 'enables AutoHide Delay for OSX Dock via com.apple.dock' do
      chef_run.converge(described_recipe)
      # Workaround a very weird problem with ChefSpec Matcher arity being different on Chef 13 vs 11 & 12
      if self.method(:write_osx_defaults).arity == 1
        expect(chef_run).to write_osx_defaults('Enable AutoHide OSX Dock (delay = 1.05)').with(domain: 'com.apple.dock', key: 'autohide-delay', float: 1.05)
      elsif self.method(:write_osx_defaults).arity == 2
        expect(chef_run).to write_osx_defaults('com.apple.dock', 'autohide-delay').with(float: 1.05)
      end
    end
  end

  context 'when given node["lyraphase_workstation"]["settings"]["autohide_delay"] = nil' do
    let(:chef_run) {
      klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
      klass.new do |node|
        # Struct.new("EtcPasswd", :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire) unless ::Object.const_defined?(:EtcPasswd)
        create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
        node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
        node.normal['lyraphase_workstation']['user'] = 'brubble'

        node.normal['lyraphase_workstation']['settings']['autohide_dock'] = nil
      end.converge(described_recipe)
    }

    it 'does not enable AutoHide Delay for OSX Dock via com.apple.dock' do
      chef_run.converge(described_recipe)
      # Workaround a very weird problem with ChefSpec Matcher arity being different on Chef 13 vs 11 & 12
      if self.method(:write_osx_defaults).arity == 1
        expect(chef_run).to_not write_osx_defaults('Enable AutoHide OSX Dock (delay = 0.0)').with(domain: 'com.apple.dock', key: 'autohide-delay', float: 0.0)
      elsif self.method(:write_osx_defaults).arity == 2
        expect(chef_run).to_not write_osx_defaults('com.apple.dock', 'autohide-delay').with(float: 0.0)
      end
    end
  end

end
