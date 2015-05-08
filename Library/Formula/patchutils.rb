class Patchutils < Formula
  homepage "http://cyberelk.net/tim/software/patchutils/"
  url "http://cyberelk.net/tim/data/patchutils/stable/patchutils-0.3.4.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/p/patchutils/patchutils_0.3.4.orig.tar.xz"
  sha256 "cf55d4db83ead41188f5b6be16f60f6b76a87d5db1c42f5459d596e81dabe876"

  head do
    url "https://github.com/twaugh/patchutils.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  bottle do
    cellar :any
    sha1 "e339d44549d5adaf0907752d87a15c74fdc14892" => :yosemite
    sha1 "1d2ef386ca2d3f17574ecdb8ca2cf3dbde142296" => :mavericks
    sha1 "56c838384a5712786d2a424a57ce69b168e1f66e" => :mountain_lion
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
