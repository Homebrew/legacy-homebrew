require 'formula'

class Pygobject < Formula
  desc "GLib/GObject/GIO Python bindings for Python 2"
  homepage 'https://live.gnome.org/PyGObject'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pygobject/2.28/pygobject-2.28.6.tar.bz2'
  sha1 '4eda7d2b97f495a2ad7d4cdc234d08ca5408d9d5'

  bottle do
    sha1 "41b026312378b3d1cc90135e68e88e72aed68fea" => :yosemite
    sha1 "5ab93e8961a6645aa4213b5deaf30acf3d7d0011" => :mavericks
    sha1 "0eb2294d2eff8f0efef2b12c8d7b7e87d0026bee" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on :python

  option :universal

  # https://bugzilla.gnome.org/show_bug.cgi?id=668522
  patch do
    url "http://git.gnome.org/browse/pygobject/patch/gio/gio-types.defs?id=42d01f060c5d764baa881d13c103d68897163a49"
    sha1 "66411f0251ac036f33239591cf3c4c0a50ccab30"
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-introspection"
    system "make install"
  end
end
