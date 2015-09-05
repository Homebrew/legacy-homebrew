class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "http://ftp.midnight-commander.org/mc-4.8.14.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mc/mc_4.8.14.orig.tar.xz"
  sha256 "6b1f74efbdf394bfab084f4d2ea2e72173de5f12cd42be2533ca2c3b72edb8e6"

  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    revision 1
    sha256 "9e25d3d107929070400bcf8f928e5adc3f77c6f4942544cbf7b26822ecc425d6" => :yosemite
    sha256 "faa3115190a66947d3141619d285c55fac451cd154be9a6ea053b37239ecd085" => :mavericks
    sha256 "e75f3aed5a28a381a1bce9461108d21e76abb094d98ad8cfe580720ad390d7e8" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl"
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

    # https://www.midnight-commander.org/ticket/3509
    inreplace libexec/"mc/ext.d/text.sh", "man -P cat -l ", "man -P cat "
  end

  test do
    assert_match "GNU Midnight Commander", shell_output("#{bin}/mc --version")
  end
end
