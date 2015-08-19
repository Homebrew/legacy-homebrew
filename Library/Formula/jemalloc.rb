class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://www.canonware.com/jemalloc/download.html"
  url "http://www.canonware.com/download/jemalloc/jemalloc-3.6.0.tar.bz2"
  sha256 "e16c2159dd3c81ca2dc3b5c9ef0d43e1f2f45b04548f42db12e7c12d7bdf84fe"
  head "https://github.com/jemalloc/jemalloc.git"
  revision 1

  bottle do
    cellar :any
    sha256 "c4439e555f79aa22adbb3b935f059dc1e1dc984644e7398362b3b34dbadd39fd" => :yosemite
    sha256 "c117b315a5c8b81d53b67474082de5fb0617fe83d510987a340247dafebe36d8" => :mavericks
    sha256 "eca61c4b66a8c6df7ef1eb48258ccdf90c91d6b4ee48e8523a3b724c83ee11bb" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--with-jemalloc-prefix="
    system "make", "install"

    # This otherwise conflicts with google-perftools
    mv "#{bin}/pprof", "#{bin}/jemalloc-pprof"
  end
end
