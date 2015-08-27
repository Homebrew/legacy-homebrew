class Pygobject < Formula
  desc "GLib/GObject/GIO Python bindings for Python 2"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/2.28/pygobject-2.28.6.tar.bz2"
  sha256 "e4bfe017fa845940184c82a4d8949db3414cb29dfc84815fb763697dc85bdcee"

  bottle do
    sha1 "41b026312378b3d1cc90135e68e88e72aed68fea" => :yosemite
    sha1 "5ab93e8961a6645aa4213b5deaf30acf3d7d0011" => :mavericks
    sha1 "0eb2294d2eff8f0efef2b12c8d7b7e87d0026bee" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :python

  option :universal

  # https://bugzilla.gnome.org/show_bug.cgi?id=668522
  patch do
    url "https://git.gnome.org/browse/pygobject/patch/gio/gio-types.defs?id=42d01f060c5d764baa881d13c103d68897163a49"
    sha256 "7bb60636a9731afd030820090062688a6b53af22c276d89d6af8db264d76edcc"
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-introspection"
    system "make", "install"
  end
end
