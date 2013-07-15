require 'formula'

class Dirac < Formula
  homepage 'http://diracvideo.org/'
  url 'http://diracvideo.org/download/dirac-research/dirac-1.0.2.tar.gz'
  sha1 '895aaad832a54b754e58f77c87d38c0c37752b0b'

  fails_with :llvm do
    build 2334
  end

  def install
    # BSD cp doesn't have '-d'
    inreplace 'doc/Makefile.in', 'cp -dR', 'cp -R'

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
