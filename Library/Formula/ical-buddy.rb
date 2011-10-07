require 'formula'

# NOTE: Using git-repo instead of zip package as the latter does not
#       include source files.

class IcalBuddy < Formula
  url 'http://hasseg.org/git-public/icalBuddy.git', :tag => 'v1.7.19',
    :using => :git
  homepage 'http://hasseg.org/icalBuddy/'
  version '1.7.19'
  md5 '719089991317e01479d666b003b925fc'

  head 'http://hasseg.org/git-public/icalBuddy.git', :using => :git

  def install
    arch = MacOS.prefer_64_bit? ? "x86_64" : "i386"
    sdk = MACOS_VERSION

    inreplace "Makefile" do |s|
      s.gsub! "-arch i386 -arch ppc $(ARCH_64BIT)", "-arch #{arch}"
      s.gsub! "-mmacosx-version-min=10.5", "-mmacosx-version-min=#{sdk}"
    end

    system "make icalBuddy icalBuddy.1 icalBuddyLocalization.1 icalBuddyConfig.1"

    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end
end
