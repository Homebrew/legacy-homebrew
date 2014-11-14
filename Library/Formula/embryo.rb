require "formula"

class Embryo < Formula
  homepage "http://trac.enlightenment.org/e/wiki/Embryo"
  url "http://download.enlightenment.org/releases/embryo-1.7.10.tar.gz"
  sha1 "4e4b3eb809211876655564920fdb773fb034f22c"

  head do
    url "http://svn.enlightenment.org/svn/e/trunk/embryo/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "eina"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
