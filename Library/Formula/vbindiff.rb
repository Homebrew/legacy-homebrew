require 'formula'

class Vbindiff < Formula
  homepage 'http://www.cjmweb.net/vbindiff/'
  url 'http://www.cjmweb.net/vbindiff/vbindiff-3.0_beta4.tar.gz'
  version '3.0_beta4'
  sha1 '0e8c63debafe3d5bb8741e0254c95457d78c7f2d'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
