require 'formula'

class Qpdf < Formula
  homepage 'http://qpdf.sourceforge.net/'
  url 'http://sourceforge.net/projects/qpdf/files/qpdf/4.0.1/qpdf-4.0.1.tar.gz'
  sha1 '029ad13e1089396df34aeee3c5e386789715112a'

  depends_on 'pcre'

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
