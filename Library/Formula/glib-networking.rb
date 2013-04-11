require 'formula'

class GlibNetworking < Formula
  homepage 'https://launchpad.net/glib-networking'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glib-networking/2.36/glib-networking-2.36.0.tar.xz'
  sha256 '190d66fbaeb023ba4f43c315f23c5372c43be6cbe857596e00990211514650d9'

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
