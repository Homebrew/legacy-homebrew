class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "http://byobu.co"
  url "https://launchpad.net/byobu/trunk/5.101/+download/byobu_5.101.orig.tar.gz"
  sha256 "15972e7a6fc877fbc4e281f75ea23c04393d99764c8f6fe129dc91d614f5c8ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a86fe5d52e406dbf457465fb163a91705e44508a94a7b811c4c9bcdbe4a1455" => :el_capitan
    sha256 "73f0f7d6e37622ddd82684246ea5357e458df912c11b25a0e4298e35c7d62a69" => :yosemite
    sha256 "ca449ba4b66017d09280d24ff3d1d0389eeee6b5d9cb84b00f2c10397c43fa5d" => :mavericks
  end

  head do
    url "https://github.com/dustinkirkland/byobu.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  conflicts_with "ctail", :because => "both install `ctail` binaries"

  depends_on "coreutils"
  depends_on "gnu-sed" # fails with BSD sed
  depends_on "tmux"
  depends_on "newt" => "with-python"

  def install
    if build.head?
      cp "./debian/changelog", "./ChangeLog"
      system "autoreconf", "-fvi"
    end
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Add the following to your shell configuration file:
      export BYOBU_PREFIX=$(brew --prefix)
    EOS
  end

  test do
    system bin/"byobu-status"
  end
end
