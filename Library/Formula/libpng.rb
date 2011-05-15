require 'formula'

class Libpng < Formula
  homepage 'http://www.libpng.org/pub/png/libpng.html'
  url 'http://sourceforge.net/projects/libpng/files/libpng15/1.5.2/libpng-1.5.2.tar.bz2/download'
  sha256 '15e45ed613586b65a4b81479bebcf4b560f2262b9593c9c09867f65a65c826b7'

  keg_only :provided_by_osx,
            "TODO: Which software depends on this newer version of libpng?"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
