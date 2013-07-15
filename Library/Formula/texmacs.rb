require 'formula'

class Texmacs < Formula
  homepage 'http://www.texmacs.org'
  url 'http://www.texmacs.org/Download/ftp/tmftp/source/TeXmacs-1.0.7.19-src.tar.gz'
  sha1 '855b8252f561b69deb45a3b80f4531a9055ea465'

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
