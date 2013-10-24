require 'formula'

class Primesieve < Formula
  homepage 'http://code.google.com/p/primesieve/'
  url 'http://primesieve.googlecode.com/files/primesieve-4.3-src.zip'
  sha1 'c256801286350a7511c91b5898b009f939093484'

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
