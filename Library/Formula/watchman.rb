require "formula"

class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  head "https://github.com/facebook/watchman.git"
  url "https://github.com/facebook/watchman/archive/v3.2.0.tar.gz"
  sha1 "b7313c240e4977ee6ea8906bdca9680db34df2e9"

  bottle do
    sha256 "89671e8b820786af65fb3cb159034636230f7cf89ca934871df4a2adb595df9d" => :yosemite
    sha256 "a6f245862f48b38010e1a22f1659468466f5b9bbff4a77db25faeba9c76cf4e3" => :mavericks
    sha256 "73f54fc034ec6be43dab94e3911fa179925a56e9c96dd53feb047400e99053b3" => :mountain_lion
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
