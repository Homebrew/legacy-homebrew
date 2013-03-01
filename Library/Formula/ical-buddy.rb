require 'formula'

class IcalBuddy < Formula
  homepage 'http://hasseg.org/icalBuddy/'
  url 'http://hasseg.org/icalBuddy/1.8.6/icalBuddy-v1.8.6.zip'
  sha1 '0383ec1545fd3e5633d0e61c8d4fd6c72a68ce8b'

  head 'http://hasseg.org/git-public/icalBuddy.git'

  def install
    system "make icalBuddy icalBuddy.1 icalBuddyLocalization.1 icalBuddyConfig.1"
    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end
end
