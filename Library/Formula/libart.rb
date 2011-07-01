require 'formula'

class Libart < Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/libart_lgpl/2.3/libart_lgpl-2.3.20.tar.bz2'
  md5 'd0ce67f2ebcef1e51a83136c69242a73'
  homepage 'http://freshmeat.net/projects/libart/'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
