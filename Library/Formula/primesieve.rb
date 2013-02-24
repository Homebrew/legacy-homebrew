require 'formula'

class Primesieve < Formula
  homepage 'http://code.google.com/p/primesieve/'
  url 'http://primesieve.googlecode.com/files/primesieve-4.1-src.zip'
  sha1 'd759dd41a1aecf32e57573bc9f0473b2061b4bf8'

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
