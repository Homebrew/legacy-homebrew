class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://www.canonware.com/jemalloc/download.html"
  url "http://www.canonware.com/download/jemalloc/jemalloc-3.6.0.tar.bz2"
  sha256 "e16c2159dd3c81ca2dc3b5c9ef0d43e1f2f45b04548f42db12e7c12d7bdf84fe"
  head "https://github.com/jemalloc/jemalloc.git"

  bottle do
    cellar :any
    revision 1
    sha1 "77d56e4b7c50ca2cc73a1754af347f183f7937bd" => :yosemite
    sha1 "f76be367e982a42544bf1363bf09aed2f868e058" => :mavericks
    sha1 "2e3be2371321580e130762d3392a599a4350c06f" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"

    # This otherwise conflicts with google-perftools
    mv "#{bin}/pprof", "#{bin}/jemalloc-pprof"
  end
end
