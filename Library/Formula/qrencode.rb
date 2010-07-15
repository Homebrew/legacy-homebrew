require 'formula'

class Qrencode <Formula
  url 'http://megaui.net/fukuchi/works/qrencode/qrencode-3.1.1.tar.gz'
  homepage 'http://megaui.net/fukuchi/works/qrencode/index.en.html'
  md5 'd97f67cbefaf577e6c15923f3cc57b6a'

  depends_on 'pkg-config'
  depends_on 'libpng'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
