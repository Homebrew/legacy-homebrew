require 'formula'

class GlibNetworking < Formula
  homepage 'https://launchpad.net/glib-networking'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glib-networking/2.32/glib-networking-2.32.3.tar.xz'
  sha256 '39fe23e86a57bb7a8a67c65668394ad0fbe2d43960c1f9d68311d5d13ef1e5cf'

  depends_on 'xz' => :build
  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'gsettings-desktop-schemas'

  def install
    system './configure', '--disable-debug', '--disable-dependency-tracking',
                          '--without-ca-certificates', "--prefix=#{prefix}"
    system 'make install'
  end
end
