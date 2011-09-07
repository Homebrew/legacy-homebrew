require 'formula'

class Chmlib < Formula
  url 'http://www.jedrea.com/chmlib/chmlib-0.40.tar.gz'
  homepage 'http://www.jedrea.com/chmlib'
  md5 '96b8e9ac52015902941862171f5daa4c'

  def install
    system "./configure", "--disable-io64", "--enable-examples", "--prefix=#{prefix}"
    system "make install"
  end
end
