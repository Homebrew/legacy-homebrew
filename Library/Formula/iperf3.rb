require "formula"

class Iperf3 < Formula
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.0.5.tar.gz"
  sha1 "4ebc5bf6456527cdf6d902f8cd810169bc00711b"
  head "https://code.google.com/p/iperf/", :using => :hg

  bottle do
    cellar :any
    sha1 "d74a919035e5ae4e205fa9a5bcb7d781691b1503" => :mavericks
    sha1 "9eb1365ce719e41e3cd0eb705714e2205f815a3b" => :mountain_lion
    sha1 "cf03918180e743e894ba5e24a5a35de8f91be863" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "clean"      # there are pre-compiled files in the tarball
    system "make", "install"
  end

  test do
    system "#{bin}/iperf3", "--version"
  end
end
