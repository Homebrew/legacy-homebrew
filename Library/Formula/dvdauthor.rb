class Dvdauthor < Formula
  desc "DVD-authoring toolset"
  homepage "http://dvdauthor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/dvdauthor/dvdauthor/0.7.1/dvdauthor-0.7.1.tar.gz"
  sha256 "501fb11b09c6eb9c5a229dcb400bd81e408cc78d34eab6749970685023c51fe9"
  revision 1

  # Dvdauthor will optionally detect ImageMagick or GraphicsMagick, too.
  # But we don't add either as deps because they are big.

  depends_on "pkg-config" => :build
  depends_on "libdvdread"
  depends_on "freetype"
  depends_on "libpng"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    ENV.j1 # Install isn't parallel-safe
    system "make", "install"
  end
end
