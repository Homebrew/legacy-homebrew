require 'formula'

class Qpdf < Formula
  homepage 'http://qpdf.sourceforge.net/'
  url 'http://sourceforge.net/projects/qpdf/files/qpdf/4.1.0/qpdf-4.1.0.tar.gz'
  sha1 '97f8e260016ed2a94d9297bd07067c303746e577'

  depends_on 'pcre'

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
