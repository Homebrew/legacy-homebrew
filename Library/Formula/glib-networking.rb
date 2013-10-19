require 'formula'

class GlibNetworking < Formula
  homepage 'https://launchpad.net/glib-networking'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glib-networking/2.38/glib-networking-2.38.1.tar.xz'
  sha256 '32ea1e504f69ff6693ac4119ad598ded50bb0440cf4484d28ef0adf8fcc85653'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'gsettings-desktop-schemas'
  depends_on 'curl-ca-bundle' => :optional

  def install
    if build.with? "curl-ca-bundle"
      curl_ca_bundle = Formula.factory('curl-ca-bundle').opt_prefix
      certs_options = "--with-ca-certificates=#{curl_ca_bundle}/share/ca-bundle.crt"
    else
      certs_options = "--without-ca-certificates"
    end

    system "./configure", "--disable-dependency-tracking",
                          certs_options,
                          "--prefix=#{prefix}"
    system "make install"
  end
end
