require "formula"

class Rest < Formula
  homepage "https://wiki.gnome.org/Projects/Librest"
  url "http://ftp.acc.umu.se/pub/GNOME/sources/rest/0.7/rest-0.7.12.tar.bz2"
  sha1 "64b121cc5f99223641e6d5445f8d3ba7ee566de5"

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
