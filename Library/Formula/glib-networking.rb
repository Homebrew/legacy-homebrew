require 'formula'

class GlibNetworking < Formula
  homepage 'https://launchpad.net/glib-networking'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glib-networking/2.40/glib-networking-2.40.0.tar.xz'
  sha256 '54e9c2d81171353794d2d2113e1311dfafd889f10993099e447b431c4e800aa4'

  bottle do
    cellar :any
    sha1 "1a1d55373f1ec279931a15c0313d7f7c9b7bf0a5" => :mavericks
    sha1 "e4fc2cae57ba13b9becfefb8869c6e18c62d1dcc" => :mountain_lion
    sha1 "67dbfa7f9fd9220690fcd3e0eb9f70ffcae5f3a9" => :lion
  end

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
