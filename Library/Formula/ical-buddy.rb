require 'formula'

# NOTE: Using git-repo instead of zip package as the latter does not
#       include source files.

class IcalBuddy < Formula
  homepage 'http://hasseg.org/icalBuddy/'
  url 'http://hasseg.org/git-public/icalBuddy.git', :tag => 'v1.8.2'
  version '1.8.2'

  head 'http://hasseg.org/git-public/icalBuddy.git'

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
