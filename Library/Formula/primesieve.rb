require 'formula'

class Primesieve < Formula
  homepage 'http://code.google.com/p/primesieve/'
  url 'http://primesieve.googlecode.com/files/primesieve-3.5-src.zip'
  sha1 '044388377a976529a2fd51006d9f7b0ae02bd868'

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
