require 'formula'

class PkgConfig < Formula
  homepage 'http://pkg-config.freedesktop.org'
  url 'http://pkg-config.freedesktop.org/releases/pkg-config-0.26.tar.gz'
  md5 '47525c26a9ba7ba14bf85e01509a7234'

  def install
    paths = %W[
        #{HOMEBREW_PREFIX}/lib/pkgconfig
        /usr/local/lib/pkgconfig
        /usr/lib/pkgconfig
        /usr/X11/lib/pkgconfig
      ].uniq
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-pc-path=#{paths*':'}"
    system "make install"
  end
end
