require "formula"

class Embryo < Formula
  homepage "http://trac.enlightenment.org/e/wiki/Embryo"
  url "http://download.enlightenment.org/releases/embryo-1.7.10.tar.gz"
  sha1 "4e4b3eb809211876655564920fdb773fb034f22c"

  bottle do
    sha1 "8f7302633c71b4cbe0ca77b12a2c9a934c10f9f8" => :yosemite
    sha1 "9edfb2b516c9934858264d3905beb7a0e2aee232" => :mavericks
    sha1 "b2d9d7f7322053097094c4afe1474eec7e19987b" => :mountain_lion
  end

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
