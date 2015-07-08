require "formula"

class Cppunit < Formula
  desc "Unit testing framework for C++"
  homepage "http://www.freedesktop.org/wiki/Software/cppunit/"
  url "http://dev-www.libreoffice.org/src/cppunit-1.13.2.tar.gz"
  sha1 "0eaf8bb1dcf4d16b12bec30d0732370390d35e6f"

  bottle do
    cellar :any
    revision 1
    sha1 "18dfd9a7ceb08906e112c192af525908bcc42663" => :yosemite
    sha1 "e27e6f4f3faac5c2f280b088a48d7c83e7faf491" => :mavericks
    sha1 "06f8e404202b942139a979911b94c725ed83795a" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
