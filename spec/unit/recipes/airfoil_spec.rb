# -*- coding: utf-8 -*-
#
# Copyright (C) © 🄯  2016-2020 James Cuzella
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'spec_helper'

content = <<EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>NSWindow Frame PTMessages</key>
  <string>426 472 428 166 0 0 1280 778 </string>
  <key>PTAPEInstallLastVersionCheck</key>
  <integer>84049920</integer>
  <key>PTDontShowAlerts</key>
  <array/>
  <key>SULastCheckTime</key>
  <date>2016-03-14T17:03:41Z</date>
  <key>aggregateStatistics</key>
  <dict>
    <key>activeCount</key>
    <dict>
      <key>1</key>
      <string>390.000000</string>
      <key>2</key>
      <string>1200.000000</string>
      <key>3</key>
      <string>450.000000</string>
      <key>4</key>
      <string>60.000000</string>
    </dict>
    <key>activeDevices</key>
    <dict>
      <key>AFSMac</key>
      <string>120.000000</string>
      <key>Bluetooth</key>
      <string>1650.000000</string>
      <key>local</key>
      <string>570.000000</string>
      <key>unknown</key>
      <string>2040.000000</string>
    </dict>
    <key>statsID</key>
    <string>BB08C3D2FED0BED0BEEFCAFE000BAD</string>
    <key>visibleDevices</key>
    <dict>
      <key>AFSMac</key>
      <string>1770.000000</string>
      <key>Bluetooth</key>
      <string>1680.000000</string>
      <key>local</key>
      <string>2100.000000</string>
      <key>unknown</key>
      <string>2100.000000</string>
    </dict>
  </dict>
  <key>audioBoard</key>
  <dict>
    <key>audioSource</key>
    <dict>
      <key>effectsPatch</key>
      <dict>
        <key>balance</key>
        <real>0.0</real>
        <key>volume</key>
        <real>1</real>
      </dict>
      <key>targetv2</key>
      <dict>
        <key>class</key>
        <string>SSSystemAudioTarget</string>
      </dict>
    </dict>
    <key>remoteControlUnit</key>
    <dict>
      <key>enabled</key>
      <true/>
      <key>reverseConnectEnabled</key>
      <true/>
    </dict>
    <key>speakerCabinet</key>
    <dict>
      <key>&lt;all&gt;</key>
      <dict>
        <key>volumeTracksSystemVolume</key>
        <false/>
      </dict>
    </dict>
  </dict>
  <key>defaultPeriodicScheduler</key>
  <dict>
    <key>events</key>
    <array>
      <dict>
        <key>identifier</key>
        <string>com.rogueamoeba.extrasinstaller.versionCheck</string>
        <key>interval</key>
        <real>432000</real>
        <key>lastFireDate</key>
        <real>479667863.31589001</real>
      </dict>
      <dict>
        <key>identifier</key>
        <string>com.rogueamoeba.ptappcontroller.versionCheck</string>
        <key>interval</key>
        <real>432000</real>
        <key>lastFireDate</key>
        <real>479667821.88943499</real>
      </dict>
      <dict>
        <key>identifier</key>
        <string>com.rogueamoeba.ptappcontroller.developerNews</string>
        <key>interval</key>
        <real>86400</real>
        <key>lastFireDate</key>
        <real>479667797.87879503</real>
      </dict>
    </array>
  </dict>
  <key>developerNews</key>
  <dict>
    <key>uuidCount</key>
    <dict>
      <key>news-2016-02-19</key>
      <integer>1</integer>
    </dict>
  </dict>
  <key>didImportVersion4Preferences</key>
  <true/>
  <key>isMainWindowVisible</key>
  <true/>
  <key>launchCount</key>
  <integer>5</integer>
  <key>localPlaybackDeviceArchive</key>
  <dict>
    <key>MAC</key>
    <string>ABCDEF000102</string>
    <key>channelCount</key>
    <integer>2</integer>
    <key>deviceName</key>
    <string>Built-in Output</string>
    <key>deviceUID</key>
    <string>AppleHDAEngineOutput:1B,0,1,1:0</string>
    <key>isInput</key>
    <false/>
    <key>isVirtual</key>
    <false/>
    <key>manufacturer</key>
    <string>Apple Inc.</string>
    <key>sourceName</key>
    <string>Internal Speakers</string>
    <key>transportType</key>
    <integer>1651274862</integer>
    <key>version</key>
    <integer>1</integer>
  </dict>
  <key>mainWindowOrigin</key>
  <string>{98, 731}</string>
  <key>speakerVolumes</key>
  <dict>
    <key>00-02-5b-43-62-7f:output</key>
    <real>0.75</real>
    <key>000102030405@fflintstone-mac</key>
    <real>0.75</real>
    <key>2345678900ff@MythTV on fflintstone-mac</key>
    <real>0.75</real>
    <key>ABCDEF000102@brubble-mac</key>
    <real>0.75</real>
    <key>com.rogueamoeba.airfoil.LocalSpeaker</key>
    <real>0.75</real>
  </dict>
  <key>syncOffsets</key>
  <dict>
    <key>00-02-0b-c3-d4-f5:output</key>
    <real>0.0</real>
    <key>000102030405@fflintstone-mac</key>
    <real>0.0050199469551444054</real>
    <key>ABCDEF000102@brubble-mac</key>
    <real>0.0033244681544601917</real>
  </dict>
  <key>versionFirstLaunched</key>
  <string>5.0.2</string>
  <key>versionHighestLaunched</key>
  <string>5.0.2</string>
  <key>versionLastLaunched</key>
  <string>5.0.2</string>
  <key>versionLowestLaunched</key>
  <string>5.0.2</string>
</dict>
</plist>
EOS

updated_content = <<EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>NSWindow Frame PTMessages</key>
  <string>426 472 428 166 0 0 1280 778 </string>
  <key>PTAPEInstallLastVersionCheck</key>
  <integer>84049920</integer>
  <key>PTDontShowAlerts</key>
  <array/>
  <key>SULastCheckTime</key>
  <date>2016-03-14T17:03:41Z</date>
  <key>aggregateStatistics</key>
  <dict>
    <key>activeCount</key>
    <dict>
      <key>1</key>
      <string>390.000000</string>
      <key>2</key>
      <string>1200.000000</string>
      <key>3</key>
      <string>450.000000</string>
      <key>4</key>
      <string>60.000000</string>
    </dict>
    <key>activeDevices</key>
    <dict>
      <key>AFSMac</key>
      <string>120.000000</string>
      <key>Bluetooth</key>
      <string>1650.000000</string>
      <key>local</key>
      <string>570.000000</string>
      <key>unknown</key>
      <string>2040.000000</string>
    </dict>
    <key>statsID</key>
    <string>BB08C3D2FED0BED0BEEFCAFE000BAD</string>
    <key>visibleDevices</key>
    <dict>
      <key>AFSMac</key>
      <string>1770.000000</string>
      <key>Bluetooth</key>
      <string>1680.000000</string>
      <key>local</key>
      <string>2100.000000</string>
      <key>unknown</key>
      <string>2100.000000</string>
    </dict>
  </dict>
  <key>audioBoard</key>
  <dict>
    <key>audioSource</key>
    <dict>
      <key>effectsPatch</key>
      <dict>
        <key>balance</key>
        <real>0.0</real>
        <key>volume</key>
        <real>1</real>
      </dict>
      <key>targetv2</key>
      <dict>
        <key>class</key>
        <string>SSSystemAudioTarget</string>
      </dict>
    </dict>
    <key>remoteControlUnit</key>
    <dict>
      <key>enabled</key>
      <true/>
      <key>reverseConnectEnabled</key>
      <true/>
    </dict>
    <key>speakerCabinet</key>
    <dict>
      <key>&lt;all&gt;</key>
      <dict>
        <key>volumeTracksSystemVolume</key>
        <false/>
      </dict>
    </dict>
  </dict>
  <key>defaultPeriodicScheduler</key>
  <dict>
    <key>events</key>
    <array>
      <dict>
        <key>identifier</key>
        <string>com.rogueamoeba.extrasinstaller.versionCheck</string>
        <key>interval</key>
        <real>432000</real>
        <key>lastFireDate</key>
        <real>479667863.31589001</real>
      </dict>
      <dict>
        <key>identifier</key>
        <string>com.rogueamoeba.ptappcontroller.versionCheck</string>
        <key>interval</key>
        <real>432000</real>
        <key>lastFireDate</key>
        <real>479667821.88943499</real>
      </dict>
      <dict>
        <key>identifier</key>
        <string>com.rogueamoeba.ptappcontroller.developerNews</string>
        <key>interval</key>
        <real>86400</real>
        <key>lastFireDate</key>
        <real>479667797.87879503</real>
      </dict>
    </array>
  </dict>
  <key>developerNews</key>
  <dict>
    <key>uuidCount</key>
    <dict>
      <key>news-2016-02-19</key>
      <integer>1</integer>
    </dict>
  </dict>
  <key>didImportVersion4Preferences</key>
  <true/>
  <key>isMainWindowVisible</key>
  <true/>
  <key>launchCount</key>
  <integer>5</integer>
  <key>localPlaybackDeviceArchive</key>
  <dict>
    <key>MAC</key>
    <string>ABCDEF000102</string>
    <key>channelCount</key>
    <integer>2</integer>
    <key>deviceName</key>
    <string>Built-in Output</string>
    <key>deviceUID</key>
    <string>AppleHDAEngineOutput:1B,0,1,1:0</string>
    <key>isInput</key>
    <false/>
    <key>isVirtual</key>
    <false/>
    <key>manufacturer</key>
    <string>Apple Inc.</string>
    <key>sourceName</key>
    <string>Internal Speakers</string>
    <key>transportType</key>
    <integer>1651274862</integer>
    <key>version</key>
    <integer>1</integer>
  </dict>
  <key>mainWindowOrigin</key>
  <string>{98, 731}</string>
  <key>registrationInfo</key>
  <dict>
    <key>Code</key>
    <string>SLUG-WORTH-ENTE-RPRI-SES0-EVER-LAST-GOBS-OPPR</string>
    <key>Name</key>
    <string>Barney Rubble</string>
  </dict>
  <key>speakerVolumes</key>
  <dict>
    <key>00-02-5b-43-62-7f:output</key>
    <real>0.75</real>
    <key>000102030405@fflintstone-mac</key>
    <real>0.75</real>
    <key>2345678900ff@MythTV on fflintstone-mac</key>
    <real>0.75</real>
    <key>ABCDEF000102@brubble-mac</key>
    <real>0.75</real>
    <key>com.rogueamoeba.airfoil.LocalSpeaker</key>
    <real>0.75</real>
  </dict>
  <key>syncOffsets</key>
  <dict>
    <key>00-02-0b-c3-d4-f5:output</key>
    <real>0.0</real>
    <key>000102030405@fflintstone-mac</key>
    <real>0.0050199469551444054</real>
    <key>ABCDEF000102@brubble-mac</key>
    <real>0.0033244681544601917</real>
  </dict>
  <key>versionFirstLaunched</key>
  <string>5.0.2</string>
  <key>versionHighestLaunched</key>
  <string>5.0.2</string>
  <key>versionLastLaunched</key>
  <string>5.0.2</string>
  <key>versionLowestLaunched</key>
  <string>5.0.2</string>
</dict>
</plist>
EOS

license_info = {
  'code' => 'SLUG-WORTH-ENTE-RPRI-SES0-EVER-LAST-GOBS-OPPR',
  'name' => 'Barney Rubble'
}

test_file = Pathname.new(Dir.tmpdir) + "plist_file_push_spec.plist"


describe "lyraphase_workstation::airfoil" do

  let(:chef_run) {
    klass = ChefSpec.constants.include?(:SoloRunner) ? ChefSpec::SoloRunner : ChefSpec::Runner
    klass.new do |node|
      create_singleton_struct "EtcPasswd", [ :name, :passwd, :uid, :gid, :gecos, :dir, :shell, :change, :uclass, :expire ]
      node.normal['etc']['passwd']['brubble'] = Struct::EtcPasswd.new('brubble', '********', 501, 20, 'Barney Rubble', '/Users/brubble', '/bin/bash', 0, '', 0)
      node.normal['lyraphase_workstation']['user'] = 'brubble'
      node.normal['lyraphase_workstation']['home'] = '/Users/brubble'
      # Override the file we will edit for tests
      node.normal['lyraphase_workstation']['airfoil']['plist_file'] = test_file
      node.normal['lyraphase_workstation']['airfoil']['license'] = license_info
    end.converge(described_recipe)
  }
  before(:all) do
    test_file.open("wb") { |f| f.write(content) }

    # ChefSpec::ServerRunner.new(step_into: ["plist_file"]) do |node|
    #   node.normal['lyraphase_workstation']['airfoil']['plist_file'] = test_file
    # end.converge(described_recipe)

  end

  it 'installs Airfoil Homebrew Cask' do
    expect(chef_run).to install_homebrew_cask('airfoil')
  end

  it "pushes the license info into plist file" do
    # File.open('/tmp/chefspec.plist', 'w') do |f|
    #   f.write(test_file.open("rb") { |f| f.read })
    # end
    # expect(test_file.open("rb") { |f| f.read }).to eq(updated_content)
    expect(chef_run).to create_plist_file('plist_file_push_spec.plist')
  end

  after(:all) do
    test_file.delete
  end
end
