require "formula"

class Iperf3 < Formula
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.0.3.tar.gz"
  sha1 "1461028a6827ed1557cd60f15e11f9b817ea590f"
  head "https://code.google.com/p/iperf/", :using => :hg

  bottle do
    cellar :any
    sha1 "fbe17a1cf116ab49f9d1cabd13c44776c9d69b63" => :mavericks
    sha1 "3adad231ab741175c1b8ef7c9e65177ebe732b8b" => :mountain_lion
    sha1 "ccee12f33d9d2f786e8d5a1fdf05a6725134e8d9" => :lion
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
