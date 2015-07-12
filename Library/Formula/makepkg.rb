class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "https://projects.archlinux.org/git/pacman.git",
      :tag => "v4.2.1",
      :revision => "068f8cec42057751f528b19cece37db13ae92541"
  revision 1

  head "https://projects.archlinux.org/git/pacman.git"

  bottle do
    sha256 "5f7bfd1819f0d614801b498f36220f05c3830237a5bbcb6043ae3beab90ebd86" => :yosemite
    sha256 "a61a79f44b9738b3e10a55edf1b72d18ef6f3d082ab83d080bf162d654b3f754" => :mavericks
    sha256 "a9efd4152ec9e10dcce8573cd6875d767dcdf28ac834881daf1d7a730c951299" => :mountain_lion
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
