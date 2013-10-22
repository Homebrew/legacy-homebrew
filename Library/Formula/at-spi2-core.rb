require 'formula'

class AtSpi2Core < Formula
  homepage 'http://a11y.org'
  url 'http://ftp.acc.umu.se/pub/GNOME/sources/at-spi2-core/2.10/at-spi2-core-2.10.0.tar.xz'
  sha256 '964155c7574220a00e11e1c0d91f2d3017ed603920eb1333ff9cbdb6a22744db'

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
