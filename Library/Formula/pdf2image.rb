require 'formula'

class Pdf2image < Formula
  url 'http://pdf2image.googlecode.com/files/pdf2image-0.53-source.tar.gz'
  homepage 'http://code.google.com/p/pdf2image/'
  md5 'df9614aa45284d2aa4c6e2596062eeb7'

  def install
    ENV.x11

    # Failing for me on a new machine without running these first
    system "ln -Fs /usr/X11/include/freetype2 /usr/local/include/"
    system "ln -Fs /usr/X11/include/ft2build.h /usr/local/include/"
    system "ln -Fs /usr/X11/lib/libfreetype.6.dylib /usr/local/lib/"
    system "ln -Fs /usr/X11/lib/libfreetype.6.dylib /usr/local/lib/libfreetype.dylib"

    system "./configure", "--prefix=#{prefix}"
    # Fix manpage install location. See:
    # http://code.google.com/p/pdf2json/issues/detail?id=2
    inreplace "Makefile", "/man/", "/share/man/"
    system "make"
    system "make install"
  end
end
