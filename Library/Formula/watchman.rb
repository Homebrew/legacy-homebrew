class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v3.7.0-brew.tar.gz"
  version "3.7.0"
  sha256 "55a3ea1ee3990a5e5c11f1a37ad5bafbb63e8002f48f449c083e598f6f332154"

  head "https://github.com/facebook/watchman.git"

  bottle do
    sha256 "988bc7562fe67087f281935d2b064c172161b036a22539c50ec04b215235749c" => :yosemite
    sha256 "ae7410503f560b5ad62277e468a477c6cf7457986834ca7e2d13871661d7a131" => :mavericks
    sha256 "cc77325547e91585adbdf7341808abbced3c352ff73742365592b1654184f2dd" => :mountain_lion
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
    # Currently fails under HOMEBREW_SANDBOX: Operation not permitted
    # "Failed to open /path/to/LaunchAgents/plist for write"
    system "#{bin}/watchman", "shutdown-server"
    system "#{bin}/watchman", "watch", testpath

    list = shell_output("#{bin}/watchman watch-list")
    if list.index(testpath).nil?
      raise "failed to watch tmpdir"
    end
    system "#{bin}/watchman", "watch-del", testpath
  end
end
