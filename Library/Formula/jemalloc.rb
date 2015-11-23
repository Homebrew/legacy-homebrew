class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://www.canonware.com/jemalloc/download.html"
  url "https://github.com/jemalloc/jemalloc/releases/download/4.0.0/jemalloc-4.0.0.tar.bz2"
  sha256 "214dbc74c3669b34219b0c5a55cb96f07cb12f44c834ed9ee64d1185ee6c3ef2"
  head "https://github.com/jemalloc/jemalloc.git"

  bottle do
    cellar :any
    sha256 "2d9d3b8a36e1ffda6d5f4c5e1fabd95f496e4562a75cafba6ae975faa49e9bcd" => :el_capitan
    sha256 "2167fc05024156684666e97527784c9a260db0c9308e604fb27fd314e4be70e7" => :yosemite
    sha256 "5f3dbdc9c6a55e0cd7b8f53a4f001f36937d7c2f6afe92fe8cd0ce3ea39b922f" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--with-jemalloc-prefix="
    system "make", "install"
  end
end
