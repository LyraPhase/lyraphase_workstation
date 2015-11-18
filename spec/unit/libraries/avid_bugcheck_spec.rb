require 'spec_helper'

describe AVIDBugCheck do
  let(:shellout_return_pkg_does_not_exist) { double(run_command: nil, error!: nil, stdout: '', stderr: '', exitstatus: 1) }
  let(:shellout_return_pkg_does_exist) { double(run_command: nil, error!: nil, stdout: '', stderr: '', exitstatus: 0) }
  let(:dummy_class) { AVIDBugCheck }
  let(:chef_run) {
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
    klass.new(:log_level => :warn) do |node|
      create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      node.set['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.set['sprout']['user'] = 'brubble'
    end
  }


  context 'when "Avid CoreAudio.plugin" file exists, but pkg id does not' do
    before(:each) do
      allow(File).to receive(:directory?).and_call_original
      allow(File).to receive(:directory?).with('/Library/Audio/Plug-Ins/HAL/Avid CoreAudio.plugin') { true }
      allow(Mixlib::ShellOut).to receive(:new) { shellout_return_pkg_does_not_exist }
    end

    describe "#is_avid_coreaudio_installed?" do
      it "returns true" do
        expect(dummy_class.is_avid_coreaudio_installed?()).to be true
      end
    end
  end

  context 'when "com.avid.avid.AvidCoreAudioPlugIn" pkg id exists, but file does not' do
    before(:each) do
      allow(File).to receive(:directory?).and_call_original
      allow(File).to receive(:directory?).with('/Library/Audio/Plug-Ins/HAL/Avid CoreAudio.plugin') { false }
      allow(Mixlib::ShellOut).to receive(:new) { shellout_return_pkg_does_exist }
      allow(shellout_return_pkg_does_exist).to receive(:live_stream=) { nil }
      allow(shellout_return_pkg_does_exist).to receive(:live_stream) { nil }
    end

    describe "#is_avid_coreaudio_installed?" do
      it "returns true" do
        expect(dummy_class.is_avid_coreaudio_installed?()).to be true
      end
    end
  end

  context 'when both AVID CoreAudio pkg id and file exist' do
    before(:each) do
      allow(File).to receive(:directory?).and_call_original
      allow(File).to receive(:directory?).with('/Library/Audio/Plug-Ins/HAL/Avid CoreAudio.plugin') { true }
      allow(Mixlib::ShellOut).to receive(:new) { shellout_return_pkg_does_not_exist }
      allow(shellout_return_pkg_does_exist).to receive(:live_stream=) { nil }
      allow(shellout_return_pkg_does_exist).to receive(:live_stream) { nil }
    end

    describe "#is_avid_coreaudio_installed?" do
      it "returns true" do
        expect(dummy_class.is_avid_coreaudio_installed?()).to be true
      end
    end
  end

  context 'when neither AVID CoreAudio pkg id or file exist, but pkg id "com.avid" is found' do
    before(:each) do
      allow(File).to receive(:directory?).and_call_original
      allow(File).to receive(:directory?).with('/Library/Audio/Plug-Ins/HAL/Avid CoreAudio.plugin') { false }

      allow(Mixlib::ShellOut).to receive(:new).and_return(shellout_return_pkg_does_not_exist)
      allow(Mixlib::ShellOut).to receive(:new).with("pkgutil --pkgs='com.avid.avid.AvidCoreAudioPlugIn'", anything).and_return(shellout_return_pkg_does_not_exist)
      allow(Mixlib::ShellOut).to receive(:new).with("pkgutil --pkgs | grep -iq com.avid", anything).and_return(shellout_return_pkg_does_exist)
      # expect(Mixlib::ShellOut).to receive(:new).at_least(1).times.with(/com.avid.avid.AvidCoreAudioPlugIn/, anything) { shellout_return_pkg_does_not_exist }
      # expect(Mixlib::ShellOut).to receive(:new).at_least(1).times.with(/grep -iq com.avid/, anything) { shellout_return_pkg_does_exist }

      allow(shellout_return_pkg_does_exist).to receive(:live_stream=) { nil }
      allow(shellout_return_pkg_does_exist).to receive(:live_stream) { nil }
      allow(shellout_return_pkg_does_not_exist).to receive(:live_stream=) { nil }
      allow(shellout_return_pkg_does_not_exist).to receive(:live_stream) { nil }
    end

    describe "#is_avid_coreaudio_installed?" do
      it "returns true" do
        expect(dummy_class.is_avid_coreaudio_installed?()).to be true
      end
    end
  end

  context 'when AVID packages & files are not found' do
    before(:each) do
      allow(File).to receive(:directory?).and_call_original
      allow(File).to receive(:directory?).with('/Library/Audio/Plug-Ins/HAL/Avid CoreAudio.plugin') { false }

      allow(Mixlib::ShellOut).to receive(:new).and_return(shellout_return_pkg_does_not_exist)

      allow(shellout_return_pkg_does_exist).to receive(:live_stream=) { nil }
      allow(shellout_return_pkg_does_exist).to receive(:live_stream) { nil }
      allow(shellout_return_pkg_does_not_exist).to receive(:live_stream=) { nil }
      allow(shellout_return_pkg_does_not_exist).to receive(:live_stream) { nil }
    end

    describe "#is_avid_coreaudio_installed?" do
      it "returns true" do
        expect(dummy_class.is_avid_coreaudio_installed?()).to be false
      end
    end
  end
end
