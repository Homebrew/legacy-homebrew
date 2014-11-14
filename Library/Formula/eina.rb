require "formula"

class Eina < Formula
  homepage "http://trac.enlightenment.org/e/wiki/Eina"
  url "http://download.enlightenment.org/releases/eina-1.7.10.tar.gz"
  sha1 "c2544357b27f59d1592a02228cb277dc6b4ef797"

  bottle do
    sha1 "58d642bbf7088e75415c2d7267c1170e7bd99c39" => :yosemite
    sha1 "17da185c9c97ac84a55fb814a69171da1db77bbf" => :mavericks
    sha1 "1310e97405ab4ff2ab1160420ac8b0f4aa74cec7" => :mountain_lion
  end

  head do
    url "http://svn.enlightenment.org/svn/e/trunk/eina/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
