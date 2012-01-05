require 'formula'

class Opal < Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/opal/3.10/opal-3.10.1.tar.bz2'
  homepage 'http://wiki.ekiga.org/'
  md5 'eda49f2c0c3649fab8b82aca0c499b1a'

  depends_on 'ptlib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
