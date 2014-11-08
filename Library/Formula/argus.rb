require "formula"

class Argus < Formula
  homepage "http://qosient.com/argus/"
  url "http://qosient.com/argus/src/argus-3.0.8.tar.gz"
  sha1 "fe9833c7f8ea4cdf7054b37024e5d007613f9571"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
