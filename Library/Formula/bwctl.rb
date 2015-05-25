class Bwctl < Formula
  homepage "http://software.internet2.edu/bwctl/"
  url "http://software.internet2.edu/sources/bwctl/bwctl-1.5.4.tar.gz"
  sha256 "e6dca6ca30c8ef4d68e6b34b011a9ff7eff3aba4a84efc19d96e3675182e40ef"

  bottle do
    cellar :any
    sha1 "b44fbe6a0a4cb82f9d5f9af6062006bbe22d163c" => :yosemite
    sha1 "318f7c3022df966510467489102ea2f3fa6ea728" => :mavericks
    sha1 "d18b048baeb365d22717b2b831c164eb1c8ba125" => :mountain_lion
  end

  depends_on "i2util" => :build
  depends_on "iperf3" => :optional
  depends_on "thrulay" => :optional

  def install
    # configure mis-sets CFLAGS for I2util
    # https://lists.internet2.edu/sympa/arc/perfsonar-user/2015-04/msg00016.html
    # https://github.com/Homebrew/homebrew/pull/38212
    inreplace "configure", 'CFLAGS="-I$I2util_dir/include $CFLAGS"', 'CFLAGS="-I$with_I2util/include $CFLAGS"'

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-I2util=#{Formula["i2util"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bwctl", "-V"
  end
end
