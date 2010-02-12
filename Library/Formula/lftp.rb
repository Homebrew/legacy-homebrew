require 'formula'

class Lftp <Formula
  url 'http://ftp.yars.free.net/pub/source/lftp/lftp-4.0.5.tar.gz'
  homepage 'http://lftp.yar.ru/'
  md5 '73ea519c9e9cdfa47b714c5c91093a0d'

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
