class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "http://ftp.midnight-commander.org/mc-4.8.14.tar.xz"
  mirror "http://ftp.osuosl.org/pub/midnightcommander/mc-4.8.14.tar.xz"
  sha256 "6b1f74efbdf394bfab084f4d2ea2e72173de5f12cd42be2533ca2c3b72edb8e6"

  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    sha256 "f970c724cc382ae72b6f96b52d7b1150103f92ff7264468f92089adb72f7399f" => :yosemite
    sha256 "ecfe69da36ed93971799b4f521fbf2cc5e88f4590820c8cc6950210493b510ce" => :mavericks
    sha256 "e666054bd7bd889492f0298df8b2a5816cb4474b7834634c481753c65a6860db" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl" if MacOS.version <= :leopard
  depends_on "s-lang"
  depends_on "libssh2"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-x",
                          "--with-screen=slang",
                          "--enable-vfs-sftp"
    system "make", "install"
  end

  test do
    assert_match "GNU Midnight Commander", shell_output("#{bin}/mc --version")
  end
end
