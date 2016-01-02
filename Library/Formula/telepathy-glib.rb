class TelepathyGlib < Formula
  desc "Telepathy GLib library for clients and connection managers"
  homepage "https://wiki.freedesktop.org/telepathy/"
  url "http://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.99.11.tar.gz"
  sha256 "268cbf0199804ecb6001c7c11e5596bc3cea40a600091c144d14f837ac90cd97"

  bottle do
    sha256 "314bbd7e9108b39854b0000aa9dd40bf8cef1036dfd95ba48e11de76298f5cc5" => :el_capitan
    sha256 "d7e9d404465e2b7790a8529d3b1d0a581672e04c2d6d4fe5c5e6e4bee0505029" => :yosemite
    sha256 "20584cfe56059ea7ad227141a56b118304c3c56f8dff8fdcba18b4dbf505fe61" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gobject-introspection"
  depends_on "dbus-glib"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes",
                          "--disable-installed-tests",
                          "--disable-installed-examples",
                          "--disable-gtk-doc-html"
    system "make", "install"
  end
end
