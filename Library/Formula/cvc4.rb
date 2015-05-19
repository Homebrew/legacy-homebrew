class Cvc4 < Formula
  desc "Open-source automatic theorem prover for SMT "
  homepage "https://cvc4.cs.nyu.edu/"
  url "https://cvc4.cs.nyu.edu/builds/src/cvc4-1.4.tar.gz"
  sha256 "76fe4ff9eb9ad7d65589efb47d41aae95f3191bd0d0c3940698a7cb2df3f7024"

  bottle do
    cellar :any
    sha256 "8c18aef83d90f85ae6d4f1beeecc30863e9882097babdfff3bc3e2652182130f" => :yosemite
    sha256 "a465f035282ee686be55186931122c65e70c1ec025ea55326bbc9de72147c360" => :mavericks
    sha256 "c517ff1710952e6b8d46517dda794017a0f620bf2b75dbdff3a24987631b6a4a" => :mountain_lion
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
