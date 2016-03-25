class Ocproxy < Formula
  desc "User-level SOCKS and port forwarding proxy"
  homepage "https://github.com/cernekee/ocproxy"
  url "https://github.com/cernekee/ocproxy/archive/v1.50.tar.gz"
  sha256 "b061d59e0b5729d7a8950d8d4e0004a9739c092a4d5daf58a3bc61b177b24e4f"
  head "https://github.com/cernekee/ocproxy.git"

  bottle do
    cellar :any
    sha256 "00c9d71151182359e906514712aa6cbde06f005b0a3fadd948c152c587d6f1fe" => :el_capitan
    sha256 "e4ae0c97d43496157428d5bf3bbd9d175a1f107f88d9d3bcd6a0bf7efb50ba79" => :yosemite
    sha256 "1777ecb325d1b0025b73445a9d31808ed6bd3351a6a398e7128f8ba836b33381" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /VPNFD.is.not.set/, shell_output("#{bin}/ocproxy 2>&1", 1)
  end
end
