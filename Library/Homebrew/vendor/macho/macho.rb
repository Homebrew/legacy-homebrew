require "#{File.dirname(__FILE__)}/macho/structure"
require "#{File.dirname(__FILE__)}/macho/headers"
require "#{File.dirname(__FILE__)}/macho/load_commands"
require "#{File.dirname(__FILE__)}/macho/sections"
require "#{File.dirname(__FILE__)}/macho/macho_file"
require "#{File.dirname(__FILE__)}/macho/fat_file"
require "#{File.dirname(__FILE__)}/macho/open"
require "#{File.dirname(__FILE__)}/macho/exceptions"
require "#{File.dirname(__FILE__)}/macho/utils"
require "#{File.dirname(__FILE__)}/macho/tools"

# The primary namespace for ruby-macho.
module MachO
  # release version
  VERSION = "0.2.2".freeze
end
