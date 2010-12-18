require 'formula'

class Mdf2iso <Formula
  url 'http://download.berlios.de/mdf2iso/mdf2iso-0.3.0-src.tar.bz2'
  homepage 'http://mdf2iso.berlios.de/'
  md5 'a190625318476a196930ac66acd8fd07'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
