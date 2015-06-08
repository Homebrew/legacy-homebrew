require "formula"

class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  head "https://github.com/facebook/watchman.git"
  url "https://github.com/facebook/watchman/archive/v3.1.tar.gz"
  sha1 "eb5572cd9cf4ce2b8e31d51ed22d5ec8cc6301ae"

  bottle do
    sha256 "dd66354cdbe2ab6a9672b6f4619e2e8123cf26f60fa10b7ffaa32fb9e93bab90" => :yosemite
    sha256 "8c8f84947bc5430ee8f5909bc2aa5dd6f49869c18cc600b24e1ae566eb5ecef5" => :mavericks
    sha256 "923fd3ac8d2ac1b3752c82bb7559e311a2bfdacf30e61e4c3e371e7fb74298e8" => :mountain_lion
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
