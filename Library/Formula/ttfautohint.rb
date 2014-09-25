require "formula"

class Ttfautohint < Formula
  homepage "http://www.freetype.org/ttfautohint"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.1/ttfautohint-1.1.tar.gz"
  sha1 "db011a93ba15b2ac56ae27e3d8de0696b305ee7b"

  bottle do
    cellar :any
    sha1 "35dab86922a01bdb464f3f8e224896a2af96d852" => :mavericks
    sha1 "0d24c11620451a6e79f50e97ebae1671ef84e283" => :mountain_lion
    sha1 "f498b23d089d1d59a72e4c9626f8b7d7cdad78f0" => :lion
  end

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
