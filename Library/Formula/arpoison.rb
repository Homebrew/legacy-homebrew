class Arpoison < Formula
  desc "UNIX arp cache update utility"
  homepage "http://www.arpoison.net/"
  url "http://www.arpoison.net/arpoison-0.7.tar.gz"
  sha256 "63571633826e413a9bdaab760425d0fab76abaf71a2b7ff6a00d1de53d83e741"

  bottle do
    cellar :any
    revision 1
    sha256 "33e496f9d1ca384ad23c50a1868fc2682352176d1cf5b37472299a9e36dc7e6c" => :el_capitan
    sha256 "9d902ac3611dd0422783aecb7d46f39dd0278f65f5cab1aa99490fb527de5e22" => :yosemite
    sha256 "0737a954fa5f4d6794f7a373b90b5d2b2008a0bf7cdc4e2fd51266485e86b983" => :mavericks
  end

  depends_on "libnet"

  def install
    system "make"
    bin.install "arpoison"
    man8.install "arpoison.8"
  end
end
