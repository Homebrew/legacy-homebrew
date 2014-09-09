require 'formula'

class Exempi < Formula
  homepage 'http://libopenraw.freedesktop.org/wiki/Exempi'
  url 'http://libopenraw.freedesktop.org/download/exempi-2.2.2.tar.bz2'
  sha1 'c0a0014e18f05aa7fac210c84788ef073718a9d8'

  depends_on 'boost'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
