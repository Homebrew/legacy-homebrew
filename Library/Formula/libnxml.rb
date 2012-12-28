require 'formula'

class Libnxml < Formula
  homepage 'http://www.autistici.org/bakunin/libnxml/'
  url 'http://www.autistici.org/bakunin/libnxml/libnxml-0.18.3.tar.gz'
  sha1 '2bcb17ea01aa953d0f8cbc116e025bb837bec4aa'

  depends_on 'curl' if MacOS.version < :lion # needs >= v7.20.1

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
