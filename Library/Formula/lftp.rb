require 'formula'

class Lftp <Formula
  url 'http://ftp.yars.free.net/pub/source/lftp/lftp-4.0.9.tar.bz2'
  homepage 'http://lftp.yar.ru/'
  md5 'd3f0cd7569e31e50370208dd77a7c41b'

  depends_on 'readline'
  depends_on 'pkg-config'
  depends_on 'gnutls'

  def install
    # Bus error
    ENV.no_optimization if MACOS_VERSION == 10.5

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
