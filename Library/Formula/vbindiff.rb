require 'formula'

class Vbindiff < Formula
  url 'http://www.cjmweb.net/vbindiff/vbindiff-3.0_beta4.tar.gz'
  version '3.0_beta4'
  sha1 '0e8c63debafe3d5bb8741e0254c95457d78c7f2d'
  homepage 'http://www.cjmweb.net/vbindiff/'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
