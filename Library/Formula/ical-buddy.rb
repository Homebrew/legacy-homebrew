require 'formula'

class IcalBuddy <Formula
  homepage 'http://hasseg.org/icalBuddy/'
  head "http://hasseg.org/git-public/icalBuddy.git", :using => :git

  def install
    if MACOS_VERSION >= 10.6 and Hardware.is_64_bit?
      arch = "x86_64"
    else
      arch = "i386"
    end

    inreplace "Makefile", "-arch i386 -arch x86_64 -arch ppc", "-arch #{arch}"
    system "make icalBuddy icalBuddy.1 icalBuddyLocalization.1 icalBuddyConfig.1"

    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end
end
