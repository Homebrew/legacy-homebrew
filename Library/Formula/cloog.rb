class Cloog < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "http://www.cloog.org/"
  url "http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.4.tar.gz"
  sha256 "325adf3710ce2229b7eeb9e84d3b539556d093ae860027185e7af8a8b00a750e"

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
    (testpath/"test").write <<-EOS.undent
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

    output = shell_output("#{bin}/cloog #{testpath}/test")
    assert_match %r{Generated from #{testpath}/test by CLooG}, output
  end
end
