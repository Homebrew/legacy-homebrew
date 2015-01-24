require 'requirement'

class UnsignedKextRequirement < Requirement
  fatal true

  satisfy { MacOS.version < :yosemite || !!ENV["HOMEBREW_KEXT_DEV_MODE"] }

  def message
    s = <<-EOS.undent
      Building this formula from source isn't possible due to OS X
      Yosemite and above's unsigned kext ban.  Loading unsigned kexts
      requires booting with the "kext-dev-mode=1" argument, which can
      be placed in the "boot-args" nvram variable.  To indicate that
      you're running with this configuration and can load unsigned kexts,
      set the environment variable "HOMEBREW_KEXT_DEV_MODE".
    EOS
    s += super
    s
  end
end
