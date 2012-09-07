require 'formula'

class IcalBuddy < Formula
  homepage 'http://hasseg.org/icalBuddy/'
  url 'http://hasseg.org/icalBuddy/1.8.4/icalBuddy-v1.8.4.zip'
  sha1 '40e11d937869a5cd90b958271043a7efac9d21bb'

  head 'http://hasseg.org/git-public/icalBuddy.git'

  def install
    system "make icalBuddy icalBuddy.1 icalBuddyLocalization.1 icalBuddyConfig.1"
    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end
end
