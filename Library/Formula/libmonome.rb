require 'formula'

class Libmonome < Formula
  head 'https://github.com/monome/libmonome.git'
  homepage 'http://monome.org'
  md5 'bf2a21ef4ccc361a6b33f099f9fade12'
  version '1.0'
  depends_on 'liblo'

  def install
    system "mkdir #{lib}"
    system "mkdir #{lib}/pkgconfig"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

end