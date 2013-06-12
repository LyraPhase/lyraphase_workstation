git node["vim_home"] do
  repository node["vim_config_git"]
  branch "master"
  revision node["vim_hash"] || "HEAD"
  action :sync
  user WS_USER
  enable_submodules true
end

%w{vimrc gvimrc}.each do |vimrc|
  link "#{WS_HOME}/.#{vimrc}" do
    to "#{node["vim_home"]}/#{vimrc}"
    owner WS_USER
    not_if { File.symlink?("#{node["vim_home"]}/#{vimrc}") }
  end
end

file "#{WS_HOME}/.vimrc.local" do
  action :touch
  owner WS_USER
  not_if { File.exists?("#{WS_HOME}/.vimrc.local") }
end
