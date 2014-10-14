require 'formula'

class Libsoup < Formula
  homepage 'http://live.gnome.org/LibSoup'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libsoup/2.46/libsoup-2.46.0.tar.xz'
  sha256 'fa3d5574c1a2df521242e2ca624a2b3057121798cab9f8f40525aa186a7b15a3'

  bottle do
    sha1 "cf3892e012dd0c9273caeb7788c7152c7e552bf7" => :mavericks
    sha1 "2adba3c1e1131bc2e75f5f2bde5c53b3dadbad6d" => :mountain_lion
    sha1 "2d63bc470c1888cd71b0e09b37f61b3328ef3785" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'glib-networking'
  depends_on 'gnutls'
  depends_on 'sqlite'
  depends_on 'gobject-introspection' => :optional

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--without-gnome",
      "--disable-tls-check"
    ]

    if build.with? "gobject-introspection"
      args << "--enable-introspection"
    else
      args << "--disable-introspection"
    end

    system "./configure", *args
    system "make install"
  end
end
