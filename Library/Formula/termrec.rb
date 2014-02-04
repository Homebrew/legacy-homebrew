require "formula"

class Termrec < Formula
  homepage "http://angband.pl/termrec.html"
  url "http://angband.pl/git/termrec/", :using => :git, :tag => "0.17"
  head "http://angband.pl/git/termrec/", :using => :git
  depends_on "libtool" => :build
  depends_on "automake" => :build
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
