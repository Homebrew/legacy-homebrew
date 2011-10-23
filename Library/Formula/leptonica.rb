require 'formula'

class Leptonica < Formula
  url 'http://www.leptonica.org/source/leptonica-1.68.tar.gz'
  homepage 'http://www.leptonica.org/'
  md5 '5cd7092f9ff2ca7e3f3e73bfcd556403'

  depends_on 'jpeg'
  depends_on 'libtiff'

  def patches
    # Leptonica is missing an #include for PNG support
    # Can be removed in 1.69
    # http://code.google.com/p/leptonica/issues/detail?id=56
    "http://leptonica.googlecode.com/issues/attachment?aid=560001000&name=zlib-include.patch&token=c41d407131e91bb18eb4f3d2d569c778"
  end

  def install
    ENV.x11
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
