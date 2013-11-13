require 'formula'

class AtSpi2Core < Formula
  homepage 'http://a11y.org'
  url 'http://ftp.acc.umu.se/pub/GNOME/sources/at-spi2-core/2.10/at-spi2-core-2.10.2.tar.xz'
  sha256 'd3da58f84f4c8e4d5fe940ecb52fb27b4d9ea2b4dcdb3e1fae0f46b5eaa2dde1'

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
