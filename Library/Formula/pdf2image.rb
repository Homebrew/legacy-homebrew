require 'formula'

class Pdf2image < Formula
  homepage 'http://code.google.com/p/pdf2image/'
  url 'http://pdf2image.googlecode.com/files/pdf2image-0.53-source.tar.gz'
  sha1 '2acc8d1597eb470fce761d3f35b548318d446c2a'

  # The dependency on :X11 was removed because it killed building on
  # Mavericks.
  depends_on 'ghostscript'
  depends_on 'freetype'

  conflicts_with 'poppler', 'xpdf',
    :because => 'pdf2image, poppler, and xpdf install conflicting executables'

  def install
    system "./configure", "--prefix=#{prefix}"

    # Fix manpage install location. See:
    # http://code.google.com/p/pdf2json/issues/detail?id=2
    inreplace "Makefile", "/man/", "/share/man/"

    system "make"
    system "make install"
  end
end
