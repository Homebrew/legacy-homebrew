require 'formula'

class Yaf <Formula
  url 'http://tools.netsa.cert.org/releases/yaf-1.0.0.2.tar.gz'
  homepage 'http://tools.netsa.cert.org/yaf/'
  md5 '3ea2dd554025ba9978c914386dd59d9c'

  depends_on 'glib'
  depends_on 'libfixbuf'

  def install
    system "./configure",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--prefix=#{prefix}",
        "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
