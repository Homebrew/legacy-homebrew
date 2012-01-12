require 'formula'

class Socat < Formula
  url 'http://www.dest-unreach.org/socat/download/socat-1.7.1.3.tar.bz2'
  homepage 'http://www.dest-unreach.org/socat/'
  md5 '2081987fb0cb0290b8105574058cb329'

  depends_on 'readline'

  def install
    # Lion requires this flag in some cases
    ENV.append "CFLAGS", "-D__APPLE_USE_RFC_3542" if 10.7 <= MACOS_VERSION

    ENV.enable_warnings # -wall causes build to fail
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
