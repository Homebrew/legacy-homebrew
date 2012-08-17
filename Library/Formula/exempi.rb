require 'formula'

class Exempi < Formula
  homepage 'http://libopenraw.freedesktop.org/wiki/Exempi'
  url 'http://libopenraw.freedesktop.org/download/exempi-2.2.0.tar.bz2'
  sha1 '8c90ee42fef86890e4850c3562f8044f9cd66cfb'

  depends_on 'boost'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-boost=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
