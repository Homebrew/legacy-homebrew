class Cvc4 < Formula
  homepage "http://cvc4.cs.nyu.edu/"
  url "http://cvc4.cs.nyu.edu/builds/src/cvc4-1.4.tar.gz"
  sha256 "76fe4ff9eb9ad7d65589efb47d41aae95f3191bd0d0c3940698a7cb2df3f7024"

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
