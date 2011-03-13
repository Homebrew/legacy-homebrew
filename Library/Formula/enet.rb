require 'formula'

class Enet < Formula
  url 'http://enet.bespin.org/download/enet-1.2.tar.gz'
  homepage 'http://enet.bespin.org'
  md5 'e0d9f468d8c6f6bfd07083b3b40f5e69'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
