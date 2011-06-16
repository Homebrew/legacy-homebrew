require 'formula'

class Dirac < Formula
  url 'http://diracvideo.org/download/dirac-research/dirac-1.0.2.tar.gz'
  md5 'a57c2c5e58062d437d9ab13dffb28f0f'
  homepage 'http://diracvideo.org/'

  fails_with_llvm

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
