require 'formula'

class Enet < Formula
  url 'http://enet.bespin.org/download/enet-1.3.3.tar.gz'
  homepage 'http://enet.bespin.org'
  md5 '4b0b69377fd4511e82e5f0921a942e59'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
