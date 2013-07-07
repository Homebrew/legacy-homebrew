require 'formula'

class AtSpi2Core < Formula
  homepage 'http://a11y.org'
  url 'http://ftp.acc.umu.se/pub/GNOME/sources/at-spi2-core/2.8/at-spi2-core-2.8.0.tar.xz'
  sha256 '1861a30fc7f583d5a567a0ba547db67ce9bd294f0d1c9f7403c96a10a481c458'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'd-bus'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=no"
    system "make install"
  end
end
