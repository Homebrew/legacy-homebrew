require 'formula'

class GlibNetworking < Formula
  homepage 'https://launchpad.net/glib-networking'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glib-networking/2.40/glib-networking-2.40.0.tar.xz'
  sha256 '54e9c2d81171353794d2d2113e1311dfafd889f10993099e447b431c4e800aa4'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'gsettings-desktop-schemas'
  depends_on 'curl-ca-bundle' => :optional

  def install
    if build.with? "curl-ca-bundle"
      curl_ca_bundle = Formula["curl-ca-bundle"].opt_prefix
      certs_options = "--with-ca-certificates=#{curl_ca_bundle}/share/ca-bundle.crt"
    else
      certs_options = "--without-ca-certificates"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          certs_options
    system "make install"
  end
end
