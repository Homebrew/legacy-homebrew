require 'formula'

class Enet < Formula
  homepage 'http://enet.bespin.org'
  url 'http://enet.bespin.org/download/enet-1.3.5.tar.gz'
  sha1 '40242c48c255f65da2b21a6123640e1f7aeaa6c2'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
