require "formula"

class Ats2Postiats < Formula
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.1.5/ATS2-Postiats-0.1.5.tgz"
  sha1 "8775d3ddfba30e61a50a3b3a8c7573a5dde716d1"

  bottle do
    cellar :any
    sha1 "dd6ca443572a1a752653f6917bcd956a0d49d4b5" => :yosemite
    sha1 "752798d63c87159bd5960ad7ff6008c1322db1e2" => :mavericks
    sha1 "325d4886ac380238ac4434d3fb5969556c2cc49d" => :mountain_lion
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
    system "#{bin}/patscc hello.dats -o hello"
    assert_match "Hello, world!", shell_output(testpath/"hello")
  end
end
