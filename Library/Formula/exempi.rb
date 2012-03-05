require 'formula'

class Exempi < Formula
  url 'http://libopenraw.freedesktop.org/download/exempi-2.2.0.tar.bz2'
  homepage 'http://libopenraw.freedesktop.org/wiki/Exempi'
  md5 'f46d96975613593ee17aaf48cd350228'

  depends_on 'boost'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-boost=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
