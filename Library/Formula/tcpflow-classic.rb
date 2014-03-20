require "formula"

class TcpflowClassic < Formula
  homepage "http://www.circlemud.org/jelson/software/tcpflow/"
  url "https://github.com/rikf/tcpflow-classic/archive/v0.22-osx.tar.gz"
  sha1 "1eccd1074141a7ef165e885cc69cdc23e55b4aa1"
  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "tcpflow"
  end
end
