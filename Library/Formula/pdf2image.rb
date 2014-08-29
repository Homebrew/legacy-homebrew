require 'formula'

class Pdf2image < Formula
  homepage 'http://code.google.com/p/pdf2image/'
  url 'https://pdf2image.googlecode.com/files/pdf2image-0.53-source.tar.gz'
  sha1 '2acc8d1597eb470fce761d3f35b548318d446c2a'

  depends_on :x11
  depends_on 'freetype'
  depends_on 'ghostscript'

  conflicts_with 'poppler', 'xpdf',
    :because => 'pdf2image, poppler, and xpdf install conflicting executables'

  def install
    system "./configure", "--prefix=#{prefix}"

    # Fix manpage install location. See:
    # http://code.google.com/p/pdf2json/issues/detail?id=2
    inreplace "Makefile", "/man/", "/share/man/"

    # Fix incorrect variable name in Makefile
    inreplace "src/Makefile", "$(srcdir)", "$(SRCDIR)"

    # Add X11 libs manually; the Makefiles don't use LDFLAGS properly
    inreplace ["src/Makefile", "xpdf/Makefile"],
      "LDFLAGS =", "LDFLAGS=-L#{MacOS::X11.lib}"

    system "make"
    system "make install"
  end
end
