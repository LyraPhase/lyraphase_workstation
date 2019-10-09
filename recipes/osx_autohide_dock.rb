if node['lyraphase_workstation']['settings']['autohide_delay']
  osx_defaults "Enable AutoHide OSX Dock (delay = #{node['lyraphase_workstation']['settings']['autohide_delay'].to_f})" do
    domain "com.apple.dock"
    key "autohide-delay"
    float node['lyraphase_workstation']['settings']['autohide_delay'].to_f
  end
end

osx_defaults "Enable AutoHide OSX Dock" do
  domain "com.apple.dock"
  key "autohide"
  bool node['lyraphase_workstation']['settings']['autohide_dock'].to_bool
end
