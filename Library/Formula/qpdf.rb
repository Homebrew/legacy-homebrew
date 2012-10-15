require 'formula'

class Qpdf < Formula
  url 'http://downloads.sourceforge.net/project/qpdf/qpdf/3.0.2/qpdf-3.0.2.tar.gz'
  homepage 'http://qpdf.sourceforge.net/'
  sha1 '0cab59b27c9adf4067ffc002db1d9262e219c364'

  depends_on 'pcre'

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
