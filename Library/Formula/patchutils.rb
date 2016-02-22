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
    revision 1
    sha256 "08689727cdf1f89cc075ec2e6e71ac456c5429067899ccb5dac12848a6c2abcd" => :el_capitan
    sha256 "df5a0b90219fe01b6934696d27782920c3e9c45152980e72a1c542006c625ae9" => :yosemite
    sha256 "84cae8e92f1e9b3f377fd6584c0811a3c3989fb898bb7596ba0d1192ae10a834" => :mavericks
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
