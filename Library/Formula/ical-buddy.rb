require 'formula'

class IcalBuddy < Formula
  desc "Get events and tasks from the OS X calendar database"
  homepage 'http://hasseg.org/icalBuddy/'
  head 'https://github.com/ali-rantakari/icalBuddy.git'
  url 'https://github.com/ali-rantakari/icalBuddy/archive/v1.8.10.tar.gz'
  sha1 'e6d64289f063cc636dd9a517c7fa50a4abe70a14'

  bottle do
    cellar :any
    sha1 "23aa4a5dc5375edfa78f0d61c6748dd71e388330" => :mavericks
    sha1 "0c95d85ea39d4c9d288e1a938e1b5f5e791c29cd" => :mountain_lion
    sha1 "a856530a9a30a218b2570b3aafb9610ab4297fb8" => :lion
  end

  def install
    args = %W[icalBuddy icalBuddy.1 icalBuddyLocalization.1
      icalBuddyConfig.1 COMPILER=#{ENV.cc}]
    system "make", *args
    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end
end
