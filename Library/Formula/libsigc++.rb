require 'formula'

class Libsigcxx <Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.2/libsigc++-2.2.8.tar.bz2'
  homepage 'http://libsigc.sourceforge.net'
  md5 '1198425eab9fd605721a278c651b8dd8'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
