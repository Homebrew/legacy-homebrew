require 'formula'

class PkgConfig < Formula
  homepage 'http://pkgconfig.freedesktop.org'
  url 'http://pkgconfig.freedesktop.org/releases/pkg-config-0.27.tar.gz'
  sha256 '79a6b43ee6633c9e6cc03eb1706370bb7a8450659845b782411f969eaba656a4'

  depends_on 'gettext'

  def install
    paths = %W[
        #{HOMEBREW_PREFIX}/lib/pkgconfig
        #{HOMEBREW_PREFIX}/share/pkgconfig
        /usr/local/lib/pkgconfig
        /usr/lib/pkgconfig
      ].uniq
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-pc-path=#{paths*':'}",
                          "--with-internal-glib"
    system "make"
    system "make check"
    system "make install"
  end
end
