require 'formula'

class Libsoup < Formula
  homepage 'http://live.gnome.org/LibSoup'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libsoup/2.46/libsoup-2.46.0.tar.xz'
  sha256 'fa3d5574c1a2df521242e2ca624a2b3057121798cab9f8f40525aa186a7b15a3'

  bottle do
    revision 1
    sha1 "dc4dcb53c9da238e99feb055e70789eb54a2e98f" => :yosemite
    sha1 "4c7ab2c3b250ace75f099f80dd9ba36f4b277550" => :mavericks
    sha1 "693146c16d4105de3716252f2da9cf35156c0328" => :mountain_lion
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
