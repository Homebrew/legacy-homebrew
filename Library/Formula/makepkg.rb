require "formula"

class Makepkg < Formula
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "ftp://ftp.archlinux.org/other/pacman/pacman-4.1.2.tar.gz"
  sha1 "ed9a40a9b532bc43e48680826d57518134132538"

  bottle do
    cellar :any
    sha1 "e3b89d1ae8609703898902b7a847716418366c01" => :mavericks
    sha1 "9dd3f631e927bb662671a8d6b40b2bf91d29e72e" => :mountain_lion
    sha1 "ad5e0e8ecf0565352c9ce8ada1fd686918e04b11" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "libarchive" => :build
  depends_on "bash"
  depends_on "fakeroot"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    cd "scripts" do
      system "make", "makepkg"
      bin.install "makepkg"
    end
    cd "etc" do
      system "make", "makepkg.conf"
      etc.install "makepkg.conf"
    end
  end

  test do
    (testpath/"PKGBUILD").write("source=(https://androidnetworktester.googlecode.com/files/10kb.txt)")
    system "#{bin}/makepkg", "-dg"
  end
end
