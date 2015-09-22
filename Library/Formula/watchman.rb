class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v3.8.0.tar.gz"
  sha256 "10d1e134e6ff110044629a517e7c69050fb9e4a26f21079b267989119987b40d"
  head "https://github.com/facebook/watchman.git"

  bottle do
    sha256 "72447a975cbe1ee5edf462e61f2a0182e291e60cb0195b47f57bca4e987a5ff6" => :el_capitan
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
    list = shell_output("#{bin}/watchman -v")
    if list.index(version).nil?
      raise "expected to see #{version} in the version output"
    end
  end
end
