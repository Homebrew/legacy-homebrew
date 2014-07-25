require "formula"

class Makepkg < Formula
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "ftp://ftp.archlinux.org/other/pacman/pacman-4.1.2.tar.gz"
  sha1 "ed9a40a9b532bc43e48680826d57518134132538"

  bottle do
    revision 1
    sha1 "302edf1a558cd607e1747a7b25e5011678cde67e" => :mavericks
    sha1 "1044a51bec7287423cad12ad2816c0534a7788f0" => :mountain_lion
    sha1 "4908957c636158ed40fbdde85f6630df36469699" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "libarchive" => :build
  depends_on "bash"
  depends_on "fakeroot"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    (testpath/"PKGBUILD").write("source=(https://androidnetworktester.googlecode.com/files/10kb.txt)")
    system "#{bin}/makepkg", "-dg"
  end
end
