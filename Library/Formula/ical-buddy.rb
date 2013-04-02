require 'formula'

class IcalBuddy < Formula
  homepage 'http://hasseg.org/icalBuddy/'
  url 'http://hasseg.org/icalBuddy/1.8.8/icalBuddy-v1.8.8.zip'
  sha1 '037a92848464a6814a312fb73e4bcdafcb88331a'

  head 'http://hasseg.org/git-public/icalBuddy.git'

  def install
    system "make icalBuddy icalBuddy.1 icalBuddyLocalization.1 icalBuddyConfig.1"
    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end
end
