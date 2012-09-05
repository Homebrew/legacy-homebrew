require 'formula'

class Esound < Formula
  homepage 'http://www.tux.org/~ricdude/EsounD.html'
  url 'http://ftp.gnome.org/pub/gnome/sources/esound/0.2/esound-0.2.41.tar.bz2'
  sha1 '6c343483b3789f439277935eaad7e478bee685ea'

  depends_on 'pkg-config' => :build
  depends_on 'audiofile'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-ipv6"
    system "make install"
  end
end
