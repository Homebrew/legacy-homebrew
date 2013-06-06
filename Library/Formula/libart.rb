require 'formula'

class Libart < Formula
  homepage 'http://freshmeat.net/projects/libart/'
  url 'http://ftp.gnome.org/pub/gnome/sources/libart_lgpl/2.3/libart_lgpl-2.3.20.tar.bz2'
  sha1 '40aa6c6c5fb27a8a45cd7aaa302a835ff374d13a'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
