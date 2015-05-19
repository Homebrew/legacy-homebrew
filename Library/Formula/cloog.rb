class Cloog < Formula
  homepage "http://www.cloog.org/"
  url "http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.3.tar.gz"
  sha256 "460c6c740acb8cdfbfbb387156b627cf731b3837605f2ec0001d079d89c69734"

  bottle do
    cellar :any
    sha256 "c33a4433346520ba6256398f722bbf3ca73c17ef10a06508ae1272d267c53148" => :yosemite
    sha256 "2296401e08d678c6b22065249fb1ad0d26475f94fe4c0ce9bb29436c7b9f6976" => :mavericks
    sha256 "f93f587d47c3062d3f3dd2705320af996ffe9ef565fd485d7eda493b225aed8c" => :mountain_lion
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
      "--with-isl-prefix=#{Formula["isl"].opt_prefix}"
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
