class Termrec < Formula
  desc "Record \"videos\" of terminal output"
  homepage "http://angband.pl/termrec.html"
  head "http://angband.pl/git/termrec/", :using => :git
  url "https://github.com/kilobyte/termrec/archive/0.17.tar.gz"
  sha256 "e3496dcb520b63036423cc72f3eaf66f690e869ef4ae508f027923062c34d84f"

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
