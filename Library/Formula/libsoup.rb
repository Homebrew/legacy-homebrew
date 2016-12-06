require 'formula'

class Libsoup < Formula
  url "http://ftp.gnome.org/pub/gnome/sources/libsoup/2.33/libsoup-2.33.6.tar.gz"
  homepage "http://live.gnome.org/LibSoup"
  md5 "9ddd4717ebb6e029ddefdfae4f44ad49"

  def install
    system "./configure --prefix=#{prefix} --without-gnome"
    system "make install"
  end
end
