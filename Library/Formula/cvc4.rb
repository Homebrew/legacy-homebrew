class Cvc4 < Formula
  desc "Open-source automatic theorem prover for SMT "
  homepage "https://cvc4.cs.nyu.edu/"
  url "https://cvc4.cs.nyu.edu/builds/src/cvc4-1.4.tar.gz"
  sha256 "76fe4ff9eb9ad7d65589efb47d41aae95f3191bd0d0c3940698a7cb2df3f7024"
  revision 1

  bottle do
    cellar :any
    sha256 "45e90f3952ba323a73d0377947de1377ab421941284a10bf1989650a8f8f0e6b" => :el_capitan
    sha256 "0fcfa3a3dcad9ecd8fa457f6568458cba0f4eb020bf541515edbc8ea525a1b0f" => :yosemite
    sha256 "784e380d0c9753764618fd81144e29f8c26f2436ac4468ae822eff70d412558d" => :mavericks
  end

  head do
    url "http://cvc4.cs.nyu.edu/builds/src/unstable/latest-unstable.tar.gz"
  end

  depends_on "boost" => :build
  depends_on "gmp"
  depends_on "libantlr3c"
  depends_on :arch => :x86_64

  def install
    args = ["--enable-static",
            "--enable-shared",
            "--with-compat",
            "--bsd",
            "--with-gmp",
            "--with-antlr-dir=#{Formula["libantlr3c"].opt_prefix}",
            "--prefix=#{prefix}"]
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"simple.cvc").write <<-EOS.undent
      x0, x1, x2, x3 : BOOLEAN;
      ASSERT x1 OR NOT x0;
      ASSERT x0 OR NOT x3;
      ASSERT x3 OR x2;
      ASSERT x1 AND NOT x1;
      % EXPECT: valid
      QUERY x2;
    EOS
    result = shell_output "#{bin}/cvc4 #{(testpath/"simple.cvc")}"
    assert_match /valid/, result
  end
end
