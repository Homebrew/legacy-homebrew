require 'brewkit'

class Libgee <Formula
  @url='http://ftp.gnome.org/pub/GNOME/sources/libgee/0.3/libgee-0.3.0.tar.bz2'
  @homepage='http://live.gnome.org/Libgee'
  @md5='1ca2b8a87950ef1b14342fb32db3e558'

  depends_on 'vala'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
