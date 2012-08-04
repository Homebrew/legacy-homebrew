require 'formula'

# NOTE: Using git-repo instead of zip package as the latter does not
#       include source files.

class IcalBuddy < Formula
  homepage 'http://hasseg.org/icalBuddy/'
  url 'http://hasseg.org/icalBuddy/1.8.4/icalBuddy-v1.8.4.zip', :tag => 'v1.8.4'
  sha1 '40e11d937869a5cd90b958271043a7efac9d21bb'
  version '1.8.4'

  head 'http://hasseg.org/git-public/icalBuddy.git'

  def install
    system "make icalBuddy icalBuddy.1 icalBuddyLocalization.1 icalBuddyConfig.1"

    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end
end
