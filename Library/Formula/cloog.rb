class Cloog < Formula
  homepage "http://www.cloog.org/"
  url "http://repo.or.cz/r/cloog.git", :revision => "dc1161c0f5ace1edf720c090fba09de8bb7e0365"
  version "0.18.3"
  head "http://repo.or.cz/r/cloog.git"

  bottle do
    cellar :any
    revision 2
    sha1 "65900e9655ab8f444ecf7edf4118caa01ca56ddb" => :yosemite
    sha1 "851f64756bb082a5a354e0992976acd70cfdacbf" => :mavericks
    sha1 "06252f0a9c453818c319b21647ebaa9a26c3f4ac" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "isl"

  def install
    system "./autogen.sh"

    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-gmp=system",
      "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
      "--with-isl=system",
      "--with-isl-prefix=#{Formula["isl"].opt_prefix}"
    ]

    args << "--with-osl=bundled"

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
