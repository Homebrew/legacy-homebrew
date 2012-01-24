require 'formula'

class Socat < Formula
  url 'http://www.dest-unreach.org/socat/download/socat-1.7.2.0.tar.bz2'
  homepage 'http://www.dest-unreach.org/socat/'
  md5 'eb563dd00b9d39a49fb62a677fc941fe'

  depends_on 'readline'

  def install
    # Lion requires this flag in some cases
    ENV.append "CFLAGS", "-D__APPLE_USE_RFC_3542" if 10.7 <= MACOS_VERSION

    ENV.enable_warnings # -wall causes build to fail
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
