require "formula"

class Termrec < Formula
  homepage "http://angband.pl/termrec.html"
  head "http://angband.pl/git/termrec/", :using => :git
  url "https://github.com/kilobyte/termrec/archive/0.17.tar.gz"
  sha1 "45df1b35b7f236fafd1e4db9c45543501dfde359"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xz"

  def install
    inreplace "autogen", "libtoolize", "glibtoolize"
    system "./autogen"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/termrec", "--help"
  end
end
