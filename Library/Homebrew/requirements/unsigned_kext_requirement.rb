require 'requirement'

class UnsignedKextRequirement < Requirement
  fatal true

  satisfy { MacOS.version < :yosemite }

  def message
    <<-EOS.undent
      OS X Mavericks or older is required for this package.
      OS X Yosemite introduced a strict unsigned kext ban which breaks this package.
      You should remove this package from your system and attempt to find upstream
      binaries to use instead.
    EOS
  end
end
