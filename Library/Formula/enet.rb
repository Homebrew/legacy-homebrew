require 'formula'

class Enet < Formula
  homepage 'http://enet.bespin.org'
  url 'http://enet.bespin.org/download/enet-1.3.11.tar.gz'
  sha1 'f1b2e49aa2bbdd7d75e889f3f6d3b0c1a56b6080'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
