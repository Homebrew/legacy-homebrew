require 'formula'

class GnomeCommon < Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/gnome-common/2.28/gnome-common-2.28.0.tar.gz'
  homepage 'http://git.gnome.org/browse/gnome-common/'
  md5 'c85414eb4538961973f9f68fcdb96c58'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
