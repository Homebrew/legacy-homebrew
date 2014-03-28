require 'formula'

class AtSpi2Core < Formula
  homepage 'http://a11y.org'
  url 'http://ftp.acc.umu.se/pub/GNOME/sources/at-spi2-core/2.12/at-spi2-core-2.12.0.tar.xz'
  sha256 'db550edd98e53b4252521459c2dcaf0f3b060a9bad52489b9dbadbaedad3fb89'

  depends_on 'pkg-config' => :build
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
