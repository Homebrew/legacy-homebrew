class Ats2Postiats < Formula
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.1.10/ATS2-Postiats-0.1.10.tgz"
  sha1 "296f9ef47e9439b0e17e00200926e1460f9e1895"

  bottle do
    cellar :any
    sha256 "a310f42d49276f332da13fa81149b5150d0ecb058d4ff8ece3055a8e4b8d1248" => :yosemite
    sha256 "f1e2d7da0d4024851357c366c563025369c922a282809c53ab53dcd67011ebe1" => :mavericks
    sha256 "0c72ab0601ac960436f5d5157f606b8be2c06d843de137a6f6208b7f2e0f6b35" => :mountain_lion
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
