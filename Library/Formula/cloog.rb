class Cloog < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "http://www.cloog.org/"
  url "http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.3.tar.gz"
  sha256 "460c6c740acb8cdfbfbb387156b627cf731b3837605f2ec0001d079d89c69734"

  bottle do
    cellar :any
    revision 3
    sha256 "249e851798964b001db4906934fd4907162fe7b43da41547804fa341a16a03ac" => :el_capitan
    sha256 "969fb3f488c9efb95cf1d631f6f2e577fa60f09c858b6cda5a477aec9f3552b3" => :yosemite
    sha256 "63786794ea49b86abd2c0e0168b36ff3489779f1de2b3dfd4ede509dcf6a5bfa" => :mavericks
    sha256 "00248fca2b492a7a32e9170e2875db55391b4881656cce3f4990f38ca04ec110" => :mountain_lion
  end

  head do
    url "http://repo.or.cz/r/cloog.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "isl"

  def install
    system "./autogen.sh" if build.head?

    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-gmp=system",
      "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
      "--with-isl=system",
      "--with-isl-prefix=#{Formula["isl"].opt_prefix}",
    ]

    args << "--with-osl=bundled" if build.head?

    system "./configure", *args
    system "make", "install"
  end

  test do
    cloog_source = <<-EOS.undent
      c

      0 2
      0

      1

      1
      0 2
      0 0 0
      0

      0
    EOS

    output = pipe_output("#{bin}/cloog /dev/stdin", cloog_source)
    assert_match %r{Generated from /dev/stdin by CLooG}, output
  end
end
