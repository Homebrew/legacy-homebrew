require "formula"

class Iperf3 < Formula
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.0.7.tar.gz"
  sha1 "267e020707c983b9649bb6cb76e3c1e7956ebfd4"
  head "https://code.google.com/p/iperf/", :using => :hg

  bottle do
    cellar :any
    sha1 "d221831fa53d4af1769e520547172d9c4fa9001f" => :mavericks
    sha1 "3c00b2fecdd5e91d3787b0cc93272ab0f2b082d3" => :mountain_lion
    sha1 "4404c405c492cb18eaa4d7c8f02b3710f80c441c" => :lion
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
