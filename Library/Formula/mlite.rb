require "formula"

class Mlite < Formula
  homepage "http://t3x.org/mlite/index.html"
  url "http://t3x.org/mlite/mlite-20141203.tgz"
  sha1 "a5320eb052091fc6491fc5c7362a3ff4cad3b390"

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
