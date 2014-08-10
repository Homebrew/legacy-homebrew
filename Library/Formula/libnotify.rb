require "formula"

class Libnotify < Formula
  homepage "https://developer.gnome.org/libnotify"
  url "http://ftp.gnome.org/pub/gnome/sources/libnotify/0.7/libnotify-0.7.6.tar.xz"
  sha1 "956ce02a9f2c9fb74a81a765358131efdb7bf536"

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'gtk+3'
  depends_on 'gtk-doc' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

