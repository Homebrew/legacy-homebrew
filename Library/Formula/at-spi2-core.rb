require 'formula'

class AtSpi2Core < Formula
  homepage 'http://a11y.org'
  url 'http://ftp.acc.umu.se/pub/GNOME/sources/at-spi2-core/2.6/at-spi2-core-2.6.3.tar.xz'
  sha256 'fc4487ae46e847cfd057b329b852cf99923772ecd2ddc29f29670c9f2b15d0ea'

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
