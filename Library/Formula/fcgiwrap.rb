require 'formula'

class Fcgiwrap < Formula
  homepage 'http://nginx.localdomain.pl/wiki/FcgiWrap'
  url 'https://github.com/gnosek/fcgiwrap/archive/1.1.0.tar.gz'
  sha1 '8e7b9140b3d96f4635352bb967715477b35caf84'

  depends_on :autoconf
  depends_on :automake
  depends_on 'fcgi'

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
