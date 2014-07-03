require "formula"

class Libgee < Formula
  homepage "https://wiki.gnome.org/Projects/Libgee"
  url "http://ftp.gnome.org/pub/GNOME/sources/libgee/0.14/libgee-0.14.0.tar.xz"
  sha1 "ca6531c8ba45cc865f2ce7b93a8b3f96e1c1505e"

  bottle do
    cellar :any
    sha1 "b5f37cdf80ea636daea2b2652d8add8dcbe37202" => :mavericks
    sha1 "d253f53b456e0e80c11395516340d8a3366f58d6" => :mountain_lion
    sha1 "610ff718b5d418a28b90c779ff205a1bfd51bf26" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gobject-introspection"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-introspection=yes"
    system "make install"
  end
end
