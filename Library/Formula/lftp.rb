require 'formula'

class Lftp <Formula
  url 'http://ftp.yars.free.net/pub/source/lftp/lftp-4.2.0.tar.bz2'
  homepage 'http://lftp.yar.ru/'
  md5 'ce17c8b96a65975928a5c964a771d6f8'

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'gnutls'

  def install
    # Bus error
    ENV.no_optimization if MACOS_VERSION == 10.5

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
