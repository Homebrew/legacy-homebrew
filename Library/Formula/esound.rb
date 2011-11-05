require 'formula'

class Esound < Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/esound/0.2/esound-0.2.41.tar.bz2'
  homepage 'http://www.tux.org/~ricdude/EsounD.html'
  md5 '8d9aad3d94d15e0d59ba9dc0ea990c6c'

  depends_on 'pkg-config' => :build
  depends_on 'audiofile'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-ipv6"
    system "make install"
  end
end
