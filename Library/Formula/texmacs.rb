require 'formula'

class Texmacs < Formula
  homepage 'http://www.texmacs.org'
  url 'http://www.texmacs.org/Download/ftp/tmftp/source/TeXmacs-1.0.7.20-src.tar.gz'
  sha1 '2865020f89c58f8eb34504cf9ecc53c03038e695'

  depends_on "qt"
  depends_on "guile"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
