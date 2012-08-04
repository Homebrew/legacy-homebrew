require 'formula'

class Libpng < Formula
  homepage 'http://www.libpng.org/pub/png/libpng.html'
  url 'http://downloads.sf.net/project/libpng/libpng15/1.5.12/libpng-1.5.12.tar.gz'
  sha1 'c329f3a9b720d7ae14e8205fa6e332236573704b'

  keg_only :provided_by_osx if MacOS.x11_installed?

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
