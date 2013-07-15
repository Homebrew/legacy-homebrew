require 'formula'

class Enet < Formula
  homepage 'http://enet.bespin.org'
  url 'http://enet.bespin.org/download/enet-1.3.6.tar.gz'
  sha1 'd4c9be28014f1a9c6352ee5aacf12c0e9f5e574d'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
