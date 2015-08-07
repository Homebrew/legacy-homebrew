class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  head "https://github.com/facebook/watchman.git"
  version "3.7.0"
  url "https://github.com/facebook/watchman/archive/v3.7.0-brew.tar.gz"
  sha256 "55a3ea1ee3990a5e5c11f1a37ad5bafbb63e8002f48f449c083e598f6f332154"

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
    system "make", "install"
  end

  test do
    system "#{bin}/watchman", "shutdown-server"
    system "#{bin}/watchman", "watch", testpath
    list = `#{bin}/watchman watch-list`
    if list.index(testpath).nil?
      raise "failed to watch tmpdir"
    end
    system "#{bin}/watchman", "watch-del", testpath
  end
end
