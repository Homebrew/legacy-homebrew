class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "https://projects.archlinux.org/git/pacman.git",
      :tag => "v4.2.1",
      :revision => "068f8cec42057751f528b19cece37db13ae92541"
  revision 1

  head "https://projects.archlinux.org/git/pacman.git"

  bottle do
    sha256 "d2230e87184cdf11947f22aa9beaf588e4682fccfd964d2449b20213630fa129" => :yosemite
    sha256 "3a5020efac5c5f9b7d4a74d950b8bcc5054a50f89b5049e711ec3aaee2c3bfe9" => :mavericks
    sha256 "17dcf87394cd744c514133ddeff9de701082bb2563b70aa4f8820f6116f7938e" => :mountain_lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "asciidoc" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libarchive" => :build
  depends_on "bash"
  depends_on "fakeroot"
  depends_on "gettext"
  depends_on "openssl"
  depends_on "gpgme" => :optional

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"

    system "make", "install"
  end

  test do
    (testpath/"PKGBUILD").write("source=(https://androidnetworktester.googlecode.com/files/10kb.txt)")
    system "#{bin}/makepkg", "-dg"
  end
end
