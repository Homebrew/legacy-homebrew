require 'requirement'
require 'extend/ARGV'

class UnsignedKextRequirement < Requirement
  fatal true

  
  satisfy { MacOS.version < :yosemite || ARGV.kext_dev_mode? }

  def message
    s = <<-EOS.undent
      Building this formula from source isn't possible due to OS X
      Yosemite and above's strict unsigned kext ban, unless you run
      in kext development mode.  To indicate that, either use the
      --kext-dev-mode argument or set the HOMEBREW_KEXT_DEV_MODE
      environment variable.
    EOS
    s += super
    s
  end
end
