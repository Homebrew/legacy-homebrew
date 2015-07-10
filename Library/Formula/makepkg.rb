class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "https://projects.archlinux.org/git/pacman.git",
      :tag => "v4.2.1",
      :revision => "068f8cec42057751f528b19cece37db13ae92541"

  head "https://projects.archlinux.org/git/pacman.git"

  bottle do
    revision 1
    sha1 "302edf1a558cd607e1747a7b25e5011678cde67e" => :mavericks
    sha1 "1044a51bec7287423cad12ad2816c0534a7788f0" => :mountain_lion
    sha1 "4908957c636158ed40fbdde85f6630df36469699" => :lion
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
