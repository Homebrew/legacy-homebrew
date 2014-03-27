require 'formula'

class Iat < Formula
  homepage 'http://iat.berlios.de/'
  url 'https://downloads.sourceforge.net/project/iat.berlios/iat-0.1.7.tar.bz2'
  sha1 '006ad57c18c399530ea07847aa0f1c34b650d439'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--includedir=#{include}/iat"
    system 'make install'
  end
end
