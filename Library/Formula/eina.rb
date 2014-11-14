require "formula"

class Eina < Formula
  homepage "http://trac.enlightenment.org/e/wiki/Eina"
  url "http://download.enlightenment.org/releases/eina-1.7.10.tar.gz"
  sha1 "c2544357b27f59d1592a02228cb277dc6b4ef797"

  bottle do
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
