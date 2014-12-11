require 'requirement'

class UnsignedKextRequirement < Requirement
  fatal true

  satisfy { MacOS.version < :yosemite }

  def initialize(tags=[])
    tags.each do |tag|
      next unless tag.is_a? Hash
      @binary ||= tag[:binary]
      @cask ||= tag[:cask]
    end
    super
  end

  def message
    s = <<-EOS.undent
      Building this formula from source isn't possible due to OS X
      Yosemite and above's strict unsigned kext ban.
    EOS

    if @cask
      s +=  <<-EOS.undent

        You can install from Homebrew Cask:
          brew install Caskroom/cask/#{@cask}
      EOS
    end

    if @binary
      s += <<-EOS.undent

        You can use the upstream binary:
          #{@binary}
      EOS
    end
  end
end
