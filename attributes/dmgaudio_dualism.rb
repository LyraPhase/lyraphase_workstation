# -*- coding: utf-8 -*-
# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
default['lyraphase_workstation']['dmgaudio_dualism']['zip']['source']      = 'http://www.lyraphase.com/doc/installers/mac/DualismMac_v1.03.zip'
default['lyraphase_workstation']['dmgaudio_dualism']['zip']['checksum']    = '978b634516385ba94f82cdecd786b6e05e4e12da2f9b75d4b80fc21471d06e8a'
default['lyraphase_workstation']['dmgaudio_dualism']['zip']['file_name']   = 'DualismMac_v1.03.zip'
default['lyraphase_workstation']['dmgaudio_dualism']['zip']['pkg_file']    = 'DualismMac_v1.03.pkg'
default['lyraphase_workstation']['dmgaudio_dualism']['zip']['app_paths']   = ['/Library/Application Support/DMGAudio/Dualism',
                                                                              '/Library/Audio/Plug-Ins/VST3/Dualism.vst3',
                                                                              '/Library/Audio/Plug-Ins/VST/Dualism.vst',
                                                                              '/Library/Application Support/Digidesign/Plug-Ins/Dualism.dpm',
                                                                              '/Library/Application Support/DMGAudio/Dualism',
                                                                              '/Library/Audio/Plug-Ins/Components/Dualism.component',
                                                                              '/Library/Application Support/Avid/Audio/Plug-Ins/Dualism.aaxplugin']
default['lyraphase_workstation']['dmgaudio_dualism']['zip']['package_id']  = 'com.dmgaudio.pkg.DualismVST3'
default['lyraphase_workstation']['dmgaudio_dualism']['license_key'] = nil
# rubocop:enable Metrics/LineLength
