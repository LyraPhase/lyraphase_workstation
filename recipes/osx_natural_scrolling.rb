osx_defaults 'Disable natural scrolling' do
  domain "/Users/#{node['sprout']['user']}/Library/Preferences/.GlobalPreferences"
  key 'com.apple.swipescrolldirection'
  boolean node['lyraphase_workstation']['settings']['natural_scrolling']
end
