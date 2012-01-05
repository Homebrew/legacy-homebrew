require 'formula'

class Ptlib < Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/ptlib/2.10/ptlib-2.10.1.tar.bz2'
  homepage 'http://wiki.ekiga.org/'
  md5 '35dfe5e21dcf96ad1d4b87099819ff1a'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
