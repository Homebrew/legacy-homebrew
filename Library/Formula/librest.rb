require "formula"

class librest < Formula
  homepage "https://wiki.gnome.org/Projects/Librest"
  url "http://ftp.acc.umu.se/pub/GNOME/sources/rest/0.7/rest-0.7.91.tar.xz"
  sha256 "838814d935143f2dc99eb79f1ac69c615e7b547339f6cd226dd0ed4d7c16b67a"

  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "libsoup" => :build
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--without-gnome",
      "--disable-tls-check",
      "--without-ca-certificates"
    system "make install" 
  end

end
