class Gmediaserver < Formula
  desc "UPnP Mediaserver"
  homepage "https://www.gnu.org/software/gmediaserver/"
  url "http://download.savannah.gnu.org/releases/gmediaserver/gmediaserver-0.13.0.tar.gz"
  sha256 "357030911bcce4ac9e47c2c9219b72e88705a8465899d4e0553bce540fb0fd12"

  bottle do
    cellar :any
    sha256 "1b20b013ea46981088574c32051c03d25e3d17a74adaac5a779823ae82281742" => :el_capitan
    sha256 "a8d5e2fbf6a6f8297a530aaf6047d2f7e5fee3a7534e21dc9cc20318c2b22488" => :yosemite
    sha256 "5aaaa3901d076d60f75ff8d68c8c93b828b7e8bf6a04806c56fe14ac68bb74bc" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libupnp"
  depends_on "libmagic"
  depends_on "id3lib" => :optional
  depends_on "taglib" => :optional

  # Patching gmediaserver because sigwaitinfo is not available on
  # OS X Snow Leopard, using sigwait instead.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/c68985023c/gmediaserver/sigwait.diff"
    sha256 "28078d44158f3750462d529d26148c80fe45879ba679ad02839fd652c9af1a42"
  end

  # Adds support for recent libupnp releases.
  # https://github.com/Homebrew/homebrew/issues/41269
  # Reported upstream 26/03/2016 to mailing list but not published yet:
  # https://lists.gnu.org/archive/html/gmediaserver-devel/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/893042fbfb/gmediaserver/libupnp_1.6.19_support.diff"
    sha256 "ca18709e79f667cf9ce049aeca62c97afd1d0a9d34bef50446e1ca4e95f44b61"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gmediaserver --version")
  end
end
