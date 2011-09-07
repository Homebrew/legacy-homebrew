require 'formula'

class Libass < Formula
  url 'http://libass.googlecode.com/files/libass-0.9.13.tar.gz'
  homepage 'http://code.google.com/p/libass/'
  md5 '006f48a9831c00914f05f830592f532c'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
