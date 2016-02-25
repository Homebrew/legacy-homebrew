class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.15.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mc/mc_4.8.15.orig.tar.xz"
  sha256 "cf4e8f5dfe419830d56ca7e5f2495898e37ebcd05da1e47ff7041446c87fba16"

  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    sha256 "614744903b7ea7d59b79ab8722b83d4537bf04a6b14c534c9e8135ab25206798" => :el_capitan
    sha256 "f15a295f0a18df0302fc79e2ce81e5d7950985d4160b3eeff7558e72ca810427" => :yosemite
    sha256 "e001897e0301e20f5d04dfc6ec728fb47ebb708ca3cae59a0cfa666771794d90" => :mavericks
  end

  option "without-nls", "Build without Native Language Support"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl"
  depends_on "s-lang"
  depends_on "libssh2"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-x
      --with-screen=slang
      --enable-vfs-sftp
    ]

    args << "--disable-nls" if build.without? "nls"

    system "./configure", *args
    system "make", "install"

    # https://www.midnight-commander.org/ticket/3509
    inreplace libexec/"mc/ext.d/text.sh", "man -P cat -l ", "man -P cat "
  end

  test do
    assert_match "GNU Midnight Commander", shell_output("#{bin}/mc --version")
  end
end
