require 'formula'

class Iperf3 < Formula
  homepage 'https://github.com/esnet/iperf'
  url 'https://github.com/esnet/iperf/archive/3.0.2.tar.gz'
  sha1 '3dacb887d4ba1b90c9fbb3ec2ae69389d40c01c8'
  head 'https://code.google.com/p/iperf/', :using => :hg

  bottle do
    cellar :any
    sha1 "4aa51bb8ab2eeac0f7152924a46bd702d723f094" => :mavericks
    sha1 "0bec442d6c6d054ee9627c93516022930ea391c2" => :mountain_lion
    sha1 "66ab71dd56b6f2f539b5ca31ba9a93643d9d647d" => :lion
  end

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
