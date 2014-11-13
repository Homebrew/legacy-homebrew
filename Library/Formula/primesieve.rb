require "formula"

class Primesieve < Formula
  homepage "http://primesieve.org/"
  url "http://dl.bintray.com/kimwalisch/primesieve/primesieve-5.4.tar.gz"
  sha1 "1309e444bde3822cdc3e953757b46750d384cc00"

  bottle do
    cellar :any
    sha1 "1cbc4ac0815279c64fa9028d25bdb22eaa8225ab" => :mavericks
    sha1 "92bdf25f8205ec5c7b192eef4c5206690ace20c8" => :mountain_lion
    sha1 "fca6af102d5594e03cc2cfd8472a2955e6778f99" => :lion
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
