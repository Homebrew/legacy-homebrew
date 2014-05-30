require 'formula'

class Xpdf < Formula
  homepage 'http://www.foolabs.com/xpdf/'
  url 'ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.04.tar.gz'
  sha1 'b9b1dbb0335742a09d0442c60fd02f4f934618bd'

  depends_on 'lesstif'
  depends_on :x11

  conflicts_with 'pdf2image', 'poppler',
    :because => 'xpdf, pdf2image, and poppler install conflicting executables'

  def install
    ENV.append_to_cflags "-I#{MacOS::X11.include} -I#{MacOS::X11.include}/freetype2"
    ENV.append "LDFLAGS", "-L#{MacOS::X11.lib}"

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
