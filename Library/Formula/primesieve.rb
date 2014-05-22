require "formula"

class Primesieve < Formula
  homepage "http://primesieve.org/"
  url "http://dl.bintray.com/kimwalisch/primesieve/primesieve-5.2.tar.gz"
  sha1 "f79aebf1ec19f22f67a61ecc620fc1693f1764e0"

  def install
    system "./configure", "--prefix=#{prefix}", "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make install"
  end

  test do
    system "#{bin}/primesieve", "2", "1000", "--count=1", "-p2"
  end
end
