require 'formula'

class Iperf3 < Formula
  homepage 'https://github.com/esnet/iperf'
  url 'https://github.com/esnet/iperf/archive/3.0.2.tar.gz'
  sha1 '3dacb887d4ba1b90c9fbb3ec2ae69389d40c01c8'
  head 'https://code.google.com/p/iperf/', :using => :hg

  depends_on :autoconf

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "clean"      # there are pre-compiled files in the tarball
    system "make", "install"
  end

  test do
    system "#{bin}/iperf3", "--version"
  end
end
