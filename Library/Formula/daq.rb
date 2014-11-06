require "formula"

class Daq < Formula
  homepage "http://www.snort.org/"
  url "https://www.snort.org/downloads/snort/daq-2.0.4.tar.gz"
  sha1 "f2d798e303959c8f2d4a31481f4983fc4d8ba1d9"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
