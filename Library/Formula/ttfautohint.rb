require "formula"

class Ttfautohint < Formula
  homepage "http://www.freetype.org/ttfautohint"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.1/ttfautohint-1.1.tar.gz"
  sha1 "db011a93ba15b2ac56ae27e3d8de0696b305ee7b"

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "harfbuzz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-qt=no"
    system "make install"
  end

  test do
    system "#{bin}/ttfautohint", "-V"
  end
end
