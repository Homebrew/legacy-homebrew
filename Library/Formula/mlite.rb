require "formula"

class Mlite < Formula
  homepage "http://t3x.org/mlite/index.html"
  url "http://t3x.org/mlite/mlite-20141127.tgz"
  sha1 "0d03f1866746d3ad322cdea74de8576dbeb317b2"

  def install
    system "make", "CC=#{ENV.cc}"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.m").write("len ` iota 1000")
    system "#{bin}/mlite", "-f", "test.m"
  end
end
