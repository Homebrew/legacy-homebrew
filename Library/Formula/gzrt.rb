class Gzrt < Formula
  desc "Gzip recovery toolkit"
  homepage "http://www.urbanophile.com/arenn/coding/gzrt/gzrt.html"
  url "http://www.urbanophile.com/arenn/coding/gzrt/gzrt-0.8.tar.gz"
  sha256 "b0b7dc53dadd8309ad9f43d6d6be7ac502c68ef854f1f9a15bd7f543e4571fee"

  def install
    system "make"
    bin.install "gzrecover"
    man1.install "gzrecover.1"
  end
end
