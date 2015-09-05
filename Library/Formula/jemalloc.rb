class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://www.canonware.com/jemalloc/download.html"
  url "https://github.com/jemalloc/jemalloc/releases/download/4.0.0/jemalloc-4.0.0.tar.bz2"
  sha256 "214dbc74c3669b34219b0c5a55cb96f07cb12f44c834ed9ee64d1185ee6c3ef2"
  head "https://github.com/jemalloc/jemalloc.git"

  bottle do
    cellar :any
    sha256 "988d311a2aea0ae12d14456b43d4c6d21c21a2490d3f8acf06d09dad22517d93" => :el_capitan
    sha256 "c4439e555f79aa22adbb3b935f059dc1e1dc984644e7398362b3b34dbadd39fd" => :yosemite
    sha256 "c117b315a5c8b81d53b67474082de5fb0617fe83d510987a340247dafebe36d8" => :mavericks
    sha256 "eca61c4b66a8c6df7ef1eb48258ccdf90c91d6b4ee48e8523a3b724c83ee11bb" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--with-jemalloc-prefix="
    system "make", "install"
  end
end
