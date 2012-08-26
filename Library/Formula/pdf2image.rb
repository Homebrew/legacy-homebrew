require 'formula'

class Pdf2image < Formula
  homepage 'http://code.google.com/p/pdf2image/'
  url 'http://pdf2image.googlecode.com/files/pdf2image-0.53-source.tar.gz'
  md5 'df9614aa45284d2aa4c6e2596062eeb7'

  depends_on :x11

  def install
    system "./configure", "--prefix=#{prefix}"

    # Fix manpage install location. See:
    # http://code.google.com/p/pdf2json/issues/detail?id=2
    inreplace "Makefile", "/man/", "/share/man/"

    # Add X11 libs manually; the Makefiles don't use LDFLAGS properly
<<<<<<< HEAD
    inreplace ["src/Makefile", "xpdf/Makefile"], "LDFLAGS =", "LDFLAGS=-L#{MacOS::XQuartz.lib}"
=======
    inreplace ["src/Makefile", "xpdf/Makefile"], "LDFLAGS =", "LDFLAGS=-L#{MacOS::X11.lib}"
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

    system "make"
    system "make install"
  end
end
