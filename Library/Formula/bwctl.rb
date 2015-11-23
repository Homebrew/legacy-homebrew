class Bwctl < Formula
  desc "Command-line tool and daemon for network measuring tools"
  homepage "http://software.internet2.edu/bwctl/"
  url "http://software.internet2.edu/sources/bwctl/bwctl-1.5.4.tar.gz"
  sha256 "e6dca6ca30c8ef4d68e6b34b011a9ff7eff3aba4a84efc19d96e3675182e40ef"

  bottle do
    cellar :any
    sha256 "c8890647536e60b3ed8599eb3239ee59fde0382e9df8b7585ee7eeb20275fc39" => :yosemite
    sha256 "f10efbf8f41f526130340cc6087ce3dfad83b71b69d21e0b01c11b3169d88bdd" => :mavericks
    sha256 "b60c679e8b498ffc23e697cb025dc6decc4f4d939e2b0874ff36291967eee18d" => :mountain_lion
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
