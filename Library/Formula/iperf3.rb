require "formula"

class Iperf3 < Formula
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.0.7.tar.gz"
  sha1 "267e020707c983b9649bb6cb76e3c1e7956ebfd4"
  head "https://code.google.com/p/iperf/", :using => :hg

  bottle do
    cellar :any
    sha1 "dbd0890d355e528d53a52c38024a6c8861eeecc2" => :mavericks
    sha1 "ec393d66a48e9b0a6707ca856779866d98e5ee00" => :mountain_lion
    sha1 "e3c88cf2a3d8345f5755bc5a7ebaca5c48c0f712" => :lion
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
