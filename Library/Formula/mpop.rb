require 'formula'

class Mpop < Formula
  url 'http://downloads.sourceforge.net/project/mpop/mpop/1.0.19/mpop-1.0.19.tar.bz2'
  homepage 'http://mpop.sourceforge.net/'
  md5 '40a48d486121a15075faee944a7b8fb7'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
