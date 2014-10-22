require 'formula'

class Liboauth < Formula
  homepage 'http://liboauth.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/liboauth/liboauth-1.0.3.tar.gz'
  sha1 '791dbb4166b5d2c843c8ff48ac17284cc0884af2'

  bottle do
    cellar :any
    revision 1
    sha1 "e45a5f09893eff5434259c1563a6d1d57333b26c" => :yosemite
    sha1 "80ef673091befb4c94efc94365271f152ac2fc0e" => :mavericks
    sha1 "f58f7890a6b3165fd4254ef921c0e85eeb73f810" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-curl"
    system "make install"
  end
end
