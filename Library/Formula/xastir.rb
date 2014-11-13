require "formula"

class Xastir < Formula
  homepage "http://www.xastir.org/"
  url "https://downloads.sourceforge.net/xastir/xastir-2.0.6.tar.gz"
  sha1 "08268961357f69baa0eb833fe76ec1e0ac878151"

  depends_on "proj"
  depends_on "pcre"
  depends_on "berkeley-db"
  depends_on "gdal"
  depends_on "libgeotiff"
  depends_on "lesstif"
  depends_on "jasper"
  depends_on "graphicsmagick"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
