class Icoutils < Formula
  desc "Create and extract MS Windows icons and cursors"
  homepage "http://www.nongnu.org/icoutils/"
  url "https://savannah.nongnu.org/download/icoutils/icoutils-0.31.0.tar.bz2"
  sha256 "a895d9d74a418d65d39a667e58ae38be79c9e726711384551d36531696f3af71"
  revision 1

  bottle do
    cellar :any
    revision 2
    sha256 "0fb8bad3fb897b97f0f2eead822a944eb146760bc1f39b691e0dfa2effe3e436" => :el_capitan
    sha256 "a9471ecf5c3db40a213a4c2ee69da5cceaba8c860e38dd7a16faa7cb8e92e5fe" => :yosemite
    sha256 "1d8710d6832ea7745299851636e7c7f13587208e7ab317970362615cd99ea578" => :mavericks
  end

  depends_on "libpng"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-rpath",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/icotool", "-l", test_fixtures("test.ico")
  end
end
