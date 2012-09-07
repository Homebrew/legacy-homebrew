require 'formula'

class Ptlib < Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/ptlib/2.10/ptlib-2.10.2.tar.bz2'
  homepage 'http://wiki.ekiga.org/'
  md5 '58cfea61b460ae9e4ac41cc877d00173'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
