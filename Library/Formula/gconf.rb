require 'formula'

class Gconf < Formula
  url 'ftp://ftp.gnome.org/pub/GNOME/sources/GConf/2.9/GConf-2.9.91.tar.gz'
  homepage 'http://projects.gnome.org/gconf/'
  md5 '39ba344cfdba395429bafec9bf3e505d'

  depends_on "orbit2"

  def install
    ENV["MAKEFLAGS"] = "j1"
    system "./configure --prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
