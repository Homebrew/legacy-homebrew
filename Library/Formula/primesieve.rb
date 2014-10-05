require "formula"

class Primesieve < Formula
  homepage "http://primesieve.org/"
  url "http://dl.bintray.com/kimwalisch/primesieve/primesieve-5.4.tar.gz"
  sha1 "1309e444bde3822cdc3e953757b46750d384cc00"

  bottle do
    cellar :any
    sha1 "e9ba88bedc4053233fcf3bcea27b2f3123f342c0" => :mavericks
    sha1 "c12381510dc4b21313848501cfa0099c9a29226e" => :mountain_lion
    sha1 "955e313a69018bb0ebd4fa2b097f322aa9662cb0" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make install"
  end

  test do
    system "#{bin}/primesieve", "2", "1000", "--count=1", "-p2"
  end
end
