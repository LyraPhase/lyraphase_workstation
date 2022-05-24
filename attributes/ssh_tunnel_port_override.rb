# -*- coding: utf-8 -*-
# frozen_string_literal: true

include_attribute 'lyraphase_workstation::home'

# rubocop:disable Metrics/LineLength
default['lyraphase_workstation']['ssh_tunnel_port_override'] = {}
default['lyraphase_workstation']['ssh_tunnel_port_override']['port'] = '8081'
default['lyraphase_workstation']['ssh_tunnel_port_override']['script'] = "#{node['lyraphase_workstation']['home']}/bin/ssh-tunnel-port-override.sh"
# rubocop:enable Metrics/LineLength
