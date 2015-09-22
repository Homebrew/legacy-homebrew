class Cppunit < Formula
  desc "Unit testing framework for C++"
  homepage "https://wiki.freedesktop.org/www/Software/cppunit/"
  url "http://dev-www.libreoffice.org/src/cppunit-1.13.2.tar.gz"
  sha256 "3f47d246e3346f2ba4d7c9e882db3ad9ebd3fcbd2e8b732f946e0e3eeb9f429f"

  bottle do
    cellar :any
    revision 1
    sha256 "27730fdd237f61dd3698e422edab55246d657f15fcbb73999d8b35087e3cb3c8" => :el_capitan
    sha1 "18dfd9a7ceb08906e112c192af525908bcc42663" => :yosemite
    sha1 "e27e6f4f3faac5c2f280b088a48d7c83e7faf491" => :mavericks
    sha1 "06f8e404202b942139a979911b94c725ed83795a" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
