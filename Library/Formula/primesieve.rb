require 'formula'

class Primesieve < Formula
  homepage 'http://code.google.com/p/primesieve/'
  url 'http://primesieve.googlecode.com/files/primesieve-3.7-src.zip'
  sha1 'd3e69fe620e8b2932992d67ea258523dd52f29a5'

  def install
    system "make", "bin", "lib",
                   "SHARED=yes",
                   "CXX=#{ENV.cxx}",
                   "CXXFLAGS=#{ENV.cxxflags}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def test
    system "#{bin}/primesieve", "-v"
  end
end
