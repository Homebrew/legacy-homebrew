class Qstat < Formula
  desc "Query Quake servers from the command-line"
  homepage "http://qstat.sourceforge.net"
  url "https://downloads.sourceforge.net/project/qstat/qstat/qstat-2.11/qstat-2.11.tar.gz"
  sha256 "16f0c0f55567597d7f2db5136a0858c56effb4481a2c821a48cd0432ea572150"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
