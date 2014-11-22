require "formula"

class Mlite < Formula
  homepage "http://t3x.org/mlite/index.html"
  url "http://t3x.org/mlite/mlite-20141121.tgz"
  sha1 "1d46d9341a1c180675a84397a21822c2a9367409"

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
