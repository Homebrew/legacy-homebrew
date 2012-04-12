require 'formula'

class Idutils < Formula
  url 'http://ftpmirror.gnu.org/idutils/idutils-4.5.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/idutils/idutils-4.5.tar.gz'
  homepage 'http://www.gnu.org/s/idutils/'
  md5 '6c5082ee7f70578bb35d4b6669d9e14c'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
