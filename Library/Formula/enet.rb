require 'formula'

class Enet < Formula
  homepage 'http://enet.bespin.org'
  url 'http://enet.bespin.org/download/enet-1.3.10.tar.gz'
  sha1 'f8f71435de60fe614866cf0b00bba24497a8e063'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
