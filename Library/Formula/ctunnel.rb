class Ctunnel < Formula
  desc "Cryptographic or plain tunnels for TCP/UDP connections"
  homepage "https://github.com/alienrobotarmy/ctunnel"
  url "http://alienrobotarmy.com/ctunnel/0.7/ctunnel-0.7.tar.gz"
  sha256 "3c90e14af75f7c31372fcdeb8ad24b5f874bfb974aa0906f25a059a2407a358f"

  bottle do
    cellar :any
    sha1 "9b9ad9c3cd1ca4841df031267945569da326cafa" => :mavericks
    sha1 "a88c00a8f24ac35f8956e3326099391d5f53d698" => :mountain_lion
  end

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
