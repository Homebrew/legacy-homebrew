require "formula"

class Watchman < Formula
  homepage "https://github.com/facebook/watchman"
  head "https://github.com/facebook/watchman.git"
  url "https://github.com/facebook/watchman/archive/v3.0.0.tar.gz"
  sha1 "cd62a0185401536455e3b6a67c3ee146e291ac9e"

  bottle do
    cellar :any
    sha1 "fb0dfbd321fdc91582fe5143d517e2365dfc6cb2" => :yosemite
    sha1 "7092fe20b0f41d8e7f21bac7310935430c7cf68e" => :mavericks
    sha1 "afe69c3e419e3b6a7dff177518451bbba6da0dfd" => :mountain_lion
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
