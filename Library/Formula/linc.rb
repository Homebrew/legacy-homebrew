require 'formula'

class Linc < Formula
  url 'http://ftp.acc.umu.se/pub/gnome/sources/linc/1.1/linc-1.1.1.tar.gz'
  md5 '33485195d0d71249bd67550e05ce590a'

  def install
    ENV["LIBS"] = "-lresolv"
    system "./configure --prefix=#{prefix}"
    system "make install"
  end
end
