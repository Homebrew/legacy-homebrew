require 'formula'

class Pdf2image < Formula
  homepage 'http://code.google.com/p/pdf2image/'
  url 'http://pdf2image.googlecode.com/files/pdf2image-0.53-source.tar.gz'
  sha1 '2acc8d1597eb470fce761d3f35b548318d446c2a'

  depends_on :x11

  # superenv strips flags that are needed for the build to succeed
  env :std

  def install
    system "./configure", "--prefix=#{prefix}"

    # Fix manpage install location. See:
    # http://code.google.com/p/pdf2json/issues/detail?id=2
    inreplace "Makefile", "/man/", "/share/man/"

    # Add X11 libs manually; the Makefiles don't use LDFLAGS properly
<<<<<<< HEAD
<<<<<<< HEAD
    inreplace ["src/Makefile", "xpdf/Makefile"], "LDFLAGS =", "LDFLAGS=-L#{MacOS::XQuartz.lib}"
=======
    inreplace ["src/Makefile", "xpdf/Makefile"], "LDFLAGS =", "LDFLAGS=-L#{MacOS::X11.lib}"
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
=======
    inreplace ["src/Makefile", "xpdf/Makefile"],
      "LDFLAGS =", "LDFLAGS=-L#{MacOS::X11.lib}"
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40

    system "make"
    system "make install"
  end
end
