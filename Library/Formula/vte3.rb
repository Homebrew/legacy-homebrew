require "formula"

class Vte3 < Formula
  homepage "http://developer.gnome.org/vte/"
  url "http://ftp.gnome.org/pub/gnome/sources/vte/0.36/vte-0.36.3.tar.xz"
  sha1 "a7acc1594eb6fa249edccb059c21132b3aa2657b"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pygtk"
  depends_on "gobject-introspection"
  depends_on :python

  def install
    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--disable-Bsymbolic",
      "--enable-introspection=yes",
    ]

    if build.with? "python"
      # pygtk-codegen-2.0 has been deprecated and replaced by
      # pygobject-codegen-2.0, but the vte Makefile does not detect this.
      ENV["PYGTK_CODEGEN"] = Formula["pygobject"].bin/"pygobject-codegen-2.0"
      args << "--enable-python"
    end

    system "./configure", *args
    system "make install"
  end
end
