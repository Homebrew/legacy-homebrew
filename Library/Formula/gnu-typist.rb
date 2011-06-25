require 'formula'

class GnuTypist < Formula
  url 'http://ftp.gnu.org/gnu/gtypist/gtypist-2.8.3.tar.bz2'
  homepage 'http://www.gnu.org/software/gtypist/'
  md5 '43be4b69315a202cccfed0efd011d66c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
