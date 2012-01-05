require 'formula'

class Ekiga < Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/ekiga/3.3/ekiga-3.3.2.tar.bz2'
  homepage 'http://wiki.ekiga.org/'
  md5 '2db9081eb65e25c2cc226409650f42c0'

  depends_on 'ptlib'
  depends_on 'opal'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end


end
