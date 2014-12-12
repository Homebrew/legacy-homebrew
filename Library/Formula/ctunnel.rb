require "formula"

class Ctunnel < Formula
  homepage "https://github.com/alienrobotarmy/ctunnel"
  url "http://alienrobotarmy.com/ctunnel/0.7/ctunnel-0.7.tar.gz"
  sha1 "9d369fe3df9ba65880caacede0e9bb9e8e79021b"

  depends_on "openssl"
  depends_on :tuntap => :recommended

  def install
    inreplace "Makefile.cfg", "TUNTAP=yes", "TUNTAP=no" if build.without? "tuntap"
    system "make"
    bin.mkpath
    system "make", "-B", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ctunnel", "-h"
  end
end
