require "formula"

class Cutter < Formula
  homepage "http://cutter.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cutter/cutter/1.2.4/cutter-1.2.4.tar.gz"
  sha1 "cf4bc0dc92fc8ac51441536544acc8a81a195a79"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib"
  depends_on "gettext"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-goffice",
                          "--disable-gstreamer",
                          "--disable-libsoup"
    system "make"
    system "make install"
  end
end
