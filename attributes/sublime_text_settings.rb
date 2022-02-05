# -*- coding: utf-8 -*-
# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
default['lyraphase_workstation']['sublime_text_settings'] = {}
default['lyraphase_workstation']['sublime_text_settings']['app_support_path'] = "#{node['lyraphase_workstation']['home']}/Library/Application Support/Sublime Text 3"
default['lyraphase_workstation']['sublime_text_settings']['shared_files_path'] =  "#{node['lyraphase_workstation']['home']}/pCloud Drive/AppData/mac/sublime-text-3"
default['lyraphase_workstation']['sublime_text_settings']['shared_files'] = [
  'Installed Packages',
  'Packages',
  'Local/License.sublime_license'
]
unless File.exists?(default['lyraphase_workstation']['sublime_text_settings']['shared_files_path'])
  Chef::Log.warn('pCloud Drive installation cannot be automated... please Enable Drive and allow kernel extensions from Recovery mode.')
  Chef::Log.warn('  https://web.archive.org/web/20211221010410/https://blog.pcloud.com/how-to-install-pcloud-drive-on-apple-devices-with-the-m1-chip/')
end
# rubocop:enable Metrics/LineLength
