require 'spec_helper'

describe AbletonLiveOptions do
  let(:dummy_class) { AbletonLiveOptions::Helpers }
  let(:chef_run) {
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
    klass.new(:log_level => :warn) do |node|
      create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      node.set['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.set['lyraphase_workstation']['user'] = 'brubble'
    end
  }


  context 'when passed valid options' do
    before(:each) do
      allow(dummy_class).to receive_message_chain(:open, :read) {''}
    end

    describe "#ableton_live_option_valid?" do
      it "returns true" do
        AbletonLiveOptions::Helpers::ALL_KNOWN_OPTIONS.each do |valid_option|
          expect(dummy_class.ableton_live_option_valid?(valid_option)).to be true
        end
      end
    end
  end

  context 'when passed invalid options' do
    before(:each) do
      allow(dummy_class).to receive_message_chain(:open, :read) {''}
    end

    describe "#ableton_live_option_valid?" do
      it "returns false" do
        expect(dummy_class.ableton_live_option_valid?('FooBarBazInvalid')).to be false
        expect(dummy_class.ableton_live_option_valid?('')).to be false
        expect(dummy_class.ableton_live_option_valid?(nil)).to be false
        expect(dummy_class.ableton_live_option_valid?(1.2)).to be false
        expect(dummy_class.ableton_live_option_valid?(10)).to be false
        expect(dummy_class.ableton_live_option_valid?(['Invalid'])).to be false
      end
    end
  end

  context 'when Ableton Options.txt documentation unavailable' do
    before(:each) do
      allow(dummy_class).to receive_message_chain(:open, :read) {''}
    end

    describe "#ableton_live_get_valid_options" do
      it "returns ALL_KNOWN_OPTIONS" do
        # Chef::Log.warn(dummy_class.ableton_live_get_valid_options)
        expect(dummy_class.ableton_live_get_valid_options.sort).to eq dummy_class::ALL_KNOWN_OPTIONS.sort
      end
    end
  end

  # context 'when edge case?' do
  #   before(:each) do
  #     allow(dummy_class).to receive_message_chain(:open, :read) {''}
  #   end
  #   describe "#is_avid_coreaudio_installed?" do
  #     pass
  #   end
  # end
end
