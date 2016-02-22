class Patchutils < Formula
  desc "Small collection of programs that operate on patch files"
  homepage "http://cyberelk.net/tim/software/patchutils/"
  url "http://cyberelk.net/tim/data/patchutils/stable/patchutils-0.3.4.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/p/patchutils/patchutils_0.3.4.orig.tar.xz"
  sha256 "cf55d4db83ead41188f5b6be16f60f6b76a87d5db1c42f5459d596e81dabe876"

  head do
    url "https://github.com/twaugh/patchutils.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "xmlto" => :build

  bottle do
    cellar :any_skip_relocation
    sha256 "90200a612c126f69319f01d17b43365e5c6aacceb86fd256d81e85d4ee5c1421" => :el_capitan
    sha256 "24f30129312fa91a40c2e4ccede817ea0ccaf51ecad8cf656089332dba78a84c" => :yosemite
    sha256 "947e0db6b163b638d885a97b336c08d48bef820ee69b3668810f63d24623e300" => :mavericks
    sha256 "58d815641c3a74f955f94cc5fa127bbc4da63547cd210bdd9385bd76ed825f64" => :mountain_lion
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match %r{a\/libexec\/NOOP}, shell_output("#{bin}/lsdiff #{test_fixtures("test.diff")}")
  end
end
