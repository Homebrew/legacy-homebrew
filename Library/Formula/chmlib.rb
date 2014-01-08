require 'formula'

class Chmlib < Formula
  homepage 'http://www.jedrea.com/chmlib'
  url 'http://www.jedrea.com/chmlib/chmlib-0.40.tar.gz'
  sha1 '8d9e4b9b79a23974aa06fb792ae652560bac5c4e'

  def install
    system "./configure", "--disable-io64", "--enable-examples", "--prefix=#{prefix}"
    system "make install"
  end
end
