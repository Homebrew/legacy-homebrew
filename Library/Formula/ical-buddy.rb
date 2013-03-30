require 'formula'

class IcalBuddy < Formula
  homepage 'http://hasseg.org/icalBuddy/'
  url 'http://hasseg.org/icalBuddy/1.8.7/icalBuddy-v1.8.7.zip'
  sha1 'd2e18473de34792d3f1cd44233711857b05dc4d3'

  head 'http://hasseg.org/git-public/icalBuddy.git'

  def install
    system "make icalBuddy icalBuddy.1 icalBuddyLocalization.1 icalBuddyConfig.1"
    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end
end
