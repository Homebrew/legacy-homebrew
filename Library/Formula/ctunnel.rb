require "formula"

class Ctunnel < Formula
  homepage "http://alienrobotarmy.com/ctunnel"
  url "http://alienrobotarmy.com/ctunnel/0.7/ctunnel-0.7.tar.gz"
  sha1 "9d369fe3df9ba65880caacede0e9bb9e8e79021b"

  depends_on "openssl"
  depends_on "tuntap"

  def install
    system "make"
    system "mkdir", "#{prefix}/bin"
    system "make", "-B", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ctunnel", "-v"
  end

end
