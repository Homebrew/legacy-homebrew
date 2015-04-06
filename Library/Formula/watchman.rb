require "formula"

class Watchman < Formula
  homepage "https://github.com/facebook/watchman"
  head "https://github.com/facebook/watchman.git"
  url "https://github.com/facebook/watchman/archive/v3.1.tar.gz"
  sha1 "eb5572cd9cf4ce2b8e31d51ed22d5ec8cc6301ae"

  bottle do
    cellar :any
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/watchman", "shutdown-server"
    system "#{bin}/watchman", "watch", testpath
    list = `#{bin}/watchman watch-list`
    if list.index(testpath) === nil then
      raise "failed to watch tmpdir"
    end
    system "#{bin}/watchman", "watch-del", testpath
  end
end
