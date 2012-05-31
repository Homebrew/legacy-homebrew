require 'formula'

class Dirac < Formula
  url 'http://diracvideo.org/download/dirac-research/dirac-1.0.2.tar.gz'
  md5 'a57c2c5e58062d437d9ab13dffb28f0f'
  homepage 'http://diracvideo.org/'

  fails_with :llvm do
    build 2334
  end

  def install
    # BSD cp doesn't have '-d'
    inreplace 'doc/Makefile.in', 'cp -dR', 'cp -R'

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
