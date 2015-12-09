class Pygobject < Formula
  desc "GLib/GObject/GIO Python bindings for Python 2"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/2.28/pygobject-2.28.6.tar.bz2"
  sha256 "e4bfe017fa845940184c82a4d8949db3414cb29dfc84815fb763697dc85bdcee"

  bottle do
    sha256 "2eeb114e8508e6e58a35ac263f39abce53b409f350e3677a0bf49980e4a9920b" => :el_capitan
    sha256 "f4bbcbe9194e8d36a93575e793cbff1281e28d591175e966a4a5aa1c55cf479c" => :yosemite
    sha256 "81f190d8f7cf5a97c25041eb17cd3d4540923a7f17926b7b9854a901bea9d7ab" => :mavericks
    sha256 "0f9ac32001eae1ac15bca6cd81dcf3f27474bf3d16dd3dbcfccdd95e1a676349" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :python

  option :universal

  # https://bugzilla.gnome.org/show_bug.cgi?id=668522
  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/master/pygobject/patch-enum-types.diff"
    sha256 "99a39c730f9af499db88684e2898a588fdae9cd20eef70675a28c2ddb004cb19"
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-introspection"
    system "make", "install"
  end
end
