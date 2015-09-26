class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "http://iperf.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/iperf/iperf-2.0.5.tar.gz"
  sha256 "636b4eff0431cea80667ea85a67ce4c68698760a9837e1e9d13096d20362265b"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
