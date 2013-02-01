require 'formula'

class Qpdf < Formula
  homepage 'http://qpdf.sourceforge.net/'
  url 'http://sourceforge.net/projects/qpdf/files/qpdf/4.0.0/qpdf-4.0.0.tar.gz'
  sha1 'c4e0238feade23ae99e456711ea25781c00bebfd'

  depends_on 'pcre'

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
