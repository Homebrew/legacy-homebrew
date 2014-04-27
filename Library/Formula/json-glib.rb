require "formula"

class JsonGlib < Formula
  homepage "http://live.gnome.org/JsonGlib"
  url "http://ftp.gnome.org/pub/gnome/sources/json-glib/1.0/json-glib-1.0.0.tar.xz"
  sha256 "dbf558d2da989ab84a27e4e13daa51ceaa97eb959c2c2f80976c9322a8f4cdde"

  bottle do
    revision 1
    sha1 "6e4d60ee9e486a5970ad184dd0740b562766a236" => :mavericks
    sha1 "ebca4951df7a6824e7f78fcbaba3b768f9b73a84" => :mountain_lion
    sha1 "26b6320e22759d47ac2b8d145fa045c5da66601b" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make install"
  end
end
