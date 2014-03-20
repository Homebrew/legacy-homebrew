require 'formula'

class Exempi < Formula
  homepage 'http://libopenraw.freedesktop.org/wiki/Exempi'
  url 'http://libopenraw.freedesktop.org/download/exempi-2.2.1.tar.bz2'
  sha1 '0ca233e81d6f6fef94ac13202ce9a66b584d482e'

  depends_on 'boost'

  # https://bugs.freedesktop.org/show_bug.cgi?id=73058
  patch do
    url "http://cgit.freedesktop.org/exempi/patch/?id=75af16b221dca0bf6a9656d5b187c3141d82c200"
    sha1 "a5ccc2f56ff685a52578ddcca2dc12105347c1d2"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
