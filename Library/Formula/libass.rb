require 'formula'

class Libass < Formula
  url 'http://libass.googlecode.com/files/libass-0.9.11.tar.bz2'
  homepage 'http://code.google.com/p/libass/'
  md5 'f9042884397002ba40aa89dc7d34f59f'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
