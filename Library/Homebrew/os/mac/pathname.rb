class Pathname
  if ENV["HOMEBREW_RUBY_MACHO"]
    require "os/mac/ruby_mach"
    include RubyMachO
  else
    require "os/mac/cctools_mach"
    include CctoolsMachO
  end
end
