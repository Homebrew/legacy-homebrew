class IcalBuddy < Formula
  desc "Get events and tasks from the OS X calendar database"
  homepage "http://hasseg.org/icalBuddy/"
  head "https://github.com/ali-rantakari/icalBuddy.git"
  url "https://github.com/ali-rantakari/icalBuddy/archive/v1.8.10.tar.gz"
  sha256 "3fb50cffd305ed6ac0ebb479e04ff254074ee5e4b1a1c279bd24c3cc56bcccb0"

  bottle do
    cellar :any
    sha256 "740d83125399a1ce92f49c3e32b289d5b7df1ccb26efb7fcbcdaf1cfef63d20b" => :mavericks
    sha256 "dd01140c9f8fc6648c322e258df3718b6fe3e78a20758178a4f1f7932f205198" => :mountain_lion
    sha256 "91b4b914f49c4a523a286b0e44e3a58e306756467a8887b97a61a26e755373db" => :lion
  end

  def install
    args = %W[icalBuddy icalBuddy.1 icalBuddyLocalization.1
              icalBuddyConfig.1 COMPILER=#{ENV.cc}]
    system "make", *args
    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end
end
