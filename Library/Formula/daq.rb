require "formula"

class Daq < Formula
  homepage "http://www.snort.org/"
  url "https://www.snort.org/downloads/snort/daq-2.0.4.tar.gz"
  sha1 "f2d798e303959c8f2d4a31481f4983fc4d8ba1d9"

  bottle do
    cellar :any
    sha1 "f3fb9c1e17455a6172cf1f43c867675115c2c990" => :yosemite
    sha1 "d257544110abe1872795e492c611cfa3d825734a" => :mavericks
    sha1 "64346e0563f43fb97fbe2d71d6359d5131351e97" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
