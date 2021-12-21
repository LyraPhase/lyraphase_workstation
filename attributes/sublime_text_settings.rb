default['lyraphase_workstation']['sublime_text_settings'] = {}
default['lyraphase_workstation']['sublime_text_settings']['app_support_path'] = "#{node['lyraphase_workstation']['home']}/Library/Application Support/Sublime Text 3"
default['lyraphase_workstation']['sublime_text_settings']['shared_files_path'] =  "#{node['lyraphase_workstation']['home']}/pCloud Drive/AppData/mac/sublime-text-3"
default['lyraphase_workstation']['sublime_text_settings']['shared_files'] =
                                            [
                                              'Installed Packages',
                                              'Packages',
                                              'Local/License.sublime_license'
                                            ]
