require "formula"

class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  head "https://github.com/facebook/watchman.git"
  url "https://github.com/facebook/watchman/archive/v3.3.0.tar.gz"
  sha256 "c8bd6b496f5d86b13c91368bf3b01346282f565c8af4f8e2f7bb6b74a48c4793"

  bottle do
    sha256 "69ae44ef507948e8f8c0ea81e591fe33bb417b4fa4249f56a64a0de978440272" => :yosemite
    sha256 "73de2ab287a7af1c35114a0e1225997e6c6309a22e2bccb91e5d7203f87fe63e" => :mavericks
    sha256 "9c4141c215435ca49848a19c22d8b600d304eac00f3ba2fb388f50e55cf1be76" => :mountain_lion
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
