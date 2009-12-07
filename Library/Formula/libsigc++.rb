require 'formula'

class Libsigcxx <Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.2/libsigc++-2.2.4.2.tar.bz2'
  homepage 'http://libsigc.sourceforge.net'
  md5 '545edbb7b54eec4f723323d3158c0e0c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
