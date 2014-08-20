require 'formula'

class IcalBuddy < Formula
  homepage 'http://hasseg.org/icalBuddy/'
  head 'https://github.com/ali-rantakari/icalBuddy.git'
  url 'https://github.com/ali-rantakari/icalBuddy/archive/v1.8.10.tar.gz'
  sha1 'e6d64289f063cc636dd9a517c7fa50a4abe70a14'

  def install
    args = %W[icalBuddy icalBuddy.1 icalBuddyLocalization.1
      icalBuddyConfig.1 COMPILER=#{ENV.cc}]
    system "make", *args
    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end
end
