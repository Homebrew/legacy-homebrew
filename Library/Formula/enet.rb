require 'formula'

class Enet < Formula
  homepage 'http://enet.bespin.org'
  url 'http://enet.bespin.org/download/enet-1.3.12.tar.gz'
  sha1 '5fd9ef590dc7bcff652e99fef3e7241b3a743f25'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
