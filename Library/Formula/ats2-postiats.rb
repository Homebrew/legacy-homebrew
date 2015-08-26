class Ats2Postiats < Formula
  desc "ATS programming language implementation"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.2.1/ATS2-Postiats-0.2.1.tgz"
  sha256 "0a0d3a7e762a7a7ae77e5d3e27ccdc43766d19316579bfa2015a9f7977e86f7b"

  bottle do
    cellar :any
    sha256 "be9ab239456434d4208d9a7cd50cb9131771729792b0c327b00b996451eb6c4d" => :yosemite
    sha256 "5d85ec1cac8ba021da8103c5dfdb1bb6eac825475c3a4a7e0a0961ea96df324a" => :mavericks
    sha256 "1cdd861830a35f51c2050621e518d5a7d1e47aca432a58e677cf85b600531959" => :mountain_lion
  end

  depends_on "gmp"

  fails_with :clang do
    cause "Trying to compile this with Clang is failure-galore."
  end

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"

    # Disable GC support for patsopt
    # https://github.com/githwxi/ATS-Postiats/issues/76
    system "make", "GCFLAG=-D_ATS_NGC", "all"
    system "make", "install"
  end

  test do
    (testpath/"hello.dats").write <<-EOS.undent
      val _ = print ("Hello, world!\n")
      implement main0 () = ()
    EOS
    system "#{bin}/patscc", "hello.dats", "-o", "hello"
    assert_match "Hello, world!", shell_output(testpath/"hello")
  end
end
