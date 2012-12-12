require 'formula'

class Flake < Formula
  homepage 'http://flake-enc.sourceforge.net'
  url "http://downloads.sourceforge.net/project/flake-enc/flake/0.11/flake-0.11.tar.bz2"
  sha1 '2dd2276c1f1ba36abb1c305185efeced06abca62'

  def install
    ENV.j1
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
