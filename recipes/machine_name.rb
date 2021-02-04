require 'mixlib/shellout'

hostname = Mixlib::ShellOut.new('hostname')
hostname.run_command

hostnames=[hostname.stdout.chop]

require 'socket'
netstat = Mixlib::ShellOut.new('netstat -ni')
netstat.run_command
real_interfaces = netstat.stdout.split("\n").select {|line| line.match(/en.*((\d+\.){3}\d+)/) }
host_ips = real_interfaces.collect {|line| line.match(/en.*?((\d+\.){3}\d+)/); Regexp.last_match(1) }
host_ips.each do |ip|
  begin
    hostnames << Socket.gethostbyaddr(ip.split(/\./).collect! {|i| i.to_i }.pack('CCCC'))[0]
  rescue SocketError
    log "no reverse lookup for \"#{ip}\""
  end
end

hostnames.each do |hostname|
  puts "My hostname: #{hostname}"
  if hostname =~ /#{node['machine_domain']}/ and hostname !~ /^dyn-/
    hostname = hostname.gsub(/\..*/,"")

    # The scutil commands need to run as root, unless
    # you're logged into the console, but we can't be sure of that.

    ["scutil --set ComputerName #{hostname}",
     "scutil --set LocalHostName #{hostname}",
     "scutil --set HostName #{hostname}",
     "hostname #{hostname}",
     "diskutil rename / #{hostname}" ].each do |host_cmd|
      puts host_cmd
    end

    ruby_block "test to see if hostname was set" do
      block do
        scutil_computer_name = Mixlib::ShellOut.new('scutil --get ComputerName')
        scutil_computer_name.run_command
        raise "Setting of hostname failed" unless hostname == scutil_computer_name.stdout.chop
      end
    end
  end
end
