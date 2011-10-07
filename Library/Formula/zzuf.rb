require 'formula'

class Zzuf < Formula
  url 'http://caca.zoy.org/files/zzuf/zzuf-0.13.tar.gz'
  homepage 'http://caca.zoy.org/wiki/zzuf'
  md5 '74579c429f9691f641a14f408997d42d'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
