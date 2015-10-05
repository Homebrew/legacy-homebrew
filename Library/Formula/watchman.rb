class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v3.8.0.tar.gz"
  sha256 "10d1e134e6ff110044629a517e7c69050fb9e4a26f21079b267989119987b40d"
  head "https://github.com/facebook/watchman.git"

  bottle do
    sha256 "ddb382dd43017beb04ad421d3b9c31b47e85206875ee01ed1f148b01949a7834" => :el_capitan
    sha256 "b8a0bd731de9802add0de92f8cf148ae816378e32df51398d688348c72458742" => :yosemite
    sha256 "31cab2af477fd9b3a326d8bf620ddb87aafb1bc6654db130e5ca22f16ac7f27a" => :mavericks
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
