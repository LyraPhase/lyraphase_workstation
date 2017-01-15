# A basic wrapper class to avoid ChefSpec ruby_block testing problems:
#  1. Only implements minimum used methods for parent Chef::Util::FileEdit class to avoid unintended side-effects
#  2. Separating this code out of ruby_block lets us test & exercise the code using a Mock Object and test fixture config file
class LyraPhase
  class ConfigFile < Chef::Util::FileEdit
    def initialize(filename)
      super(filename)
    end

    def insert_line_if_no_match(pattern, line)
      super(pattern, line)
    end

    def write_file()
      super()
    end

    def unwritten_changes?()
      super()
    end

    def file_edited?()
      super()
    end
  end
end

class LyraPhase
  module Helpers
    # Separate the code from the recipe so:
    #  - ChefSpec tests can call the helper method
    #  - Recipe calls same helper method
    #  - Code follows D.R.Y.
    #  - Ensure that tested behavior always matches Recipe's behavior
    def add_streamlocalbindunlink_to_sshd_config()
      file = LyraPhase::ConfigFile.new("/etc/ssh/sshd_config")
      file.insert_line_if_no_match(/.*Remove stale forwarding sockets.*/, "# Remove stale forwarding sockets (https://wiki.gnupg.org/AgentForwarding)")
      file.insert_line_if_no_match(/.*StreamLocalBindUnlink.*/, "StreamLocalBindUnlink yes")
      file.write_file
    end
  end
end


Chef::Recipe.send(:include, LyraPhase::Helpers)
