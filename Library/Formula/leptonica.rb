require 'formula'

class Leptonica < Formula
  url 'http://www.leptonica.org/source/leptonica-1.68.tar.gz'
  homepage 'http://www.leptonica.org/'
  md5 '5cd7092f9ff2ca7e3f3e73bfcd556403'

  depends_on 'jpeg'
  depends_on 'libtiff'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
