require 'formula'

class GlibNetworking < Formula
  homepage 'https://launchpad.net/glib-networking'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glib-networking/2.36/glib-networking-2.36.2.tar.xz'
  sha256 '2108d55b0af3eea56ce256830bcaf1519d6337e0054ef2eff80f2c0ef0eb23f9'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'gsettings-desktop-schemas'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--without-ca-certificates",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
