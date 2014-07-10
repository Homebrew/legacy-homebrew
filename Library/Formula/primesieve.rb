require "formula"

class Primesieve < Formula
  homepage "http://primesieve.org/"
  url "http://dl.bintray.com/kimwalisch/primesieve/primesieve-5.3.tar.gz"
  sha1 "dac89a72cc3789035149a7d2cfa48ef7d722fd8a"

  def install
    system "./configure", "--prefix=#{prefix}", "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make install"
  end

  test do
    system "#{bin}/primesieve", "2", "1000", "--count=1", "-p2"
  end
end
