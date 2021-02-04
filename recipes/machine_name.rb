#
# Cookbook Name:: lyraphase_workstation
# Recipe:: machine_name
#
# Copyright (C) © 🄯  2013-2021 James Cuzella
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
#

def hostname
  cmd = Mixlib::ShellOut.new('hostname')
  cmd.run_command
  cmd.stdout.chomp
end

def real_interfaces
  cmd = Mixlib::ShellOut.new('netstat -ni')
  cmd.run_command
  cmd.stdout.split("\n").select { |line| line.match(/en.*((\d+\.){3}\d+)/) }
end

hostnames = [hostname]

require 'socket'
host_ips = real_interfaces.collect do |line|
  line =~ /en.*?((\d+\.){3}\d+)/
  Regexp.last_match(1)
end

host_ips.each do |ip|
  begin
    hostnames << Socket.gethostbyaddr(ip.split(/\./).collect!(&:to_i).pack('CCCC'))[0]
  rescue SocketError
    log "no reverse lookup for \"#{ip}\""
  end
end

hostnames.uniq.each do |hostname|
  log "My hostname: #{hostname}"
  next unless hostname =~ /#{node['machine_domain']}/ && hostname !~ /^dyn-/
  hostname = hostname.gsub(/\..*/, '')

  # The scutil commands need to run as root, unless
  # you're logged into the console, but we can't be sure of that.

  ["scutil --set ComputerName #{hostname}",
   "scutil --set LocalHostName #{hostname}",
   "scutil --set HostName #{hostname}",
   "hostname #{hostname}",
   "diskutil rename / #{hostname}"].each do |host_cmd|
    execute host_cmd
  end

  ruby_block "test to see if hostname (#{hostname}) was set" do
    block do
      cmd = Mixlib::ShellOut.new('scutil --get ComputerName')
      cmd.run_command
      computer_name = cmd.stdout.chomp

      raise 'Setting of hostname failed' unless hostname == computer_name
    end
  end
end
