class Ats2Postiats < Formula
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.1.11/ATS2-Postiats-0.1.11.tgz"
  sha1 "89f664ca39fe90057a789f867d6c9f30df5f8c9a"

  bottle do
    cellar :any
    sha256 "5230ba943a43a1378e89afa29e15b64d906feaba91500b6444c7b873f2cf37a9" => :yosemite
    sha256 "5c7edda3dff25844035867982eb9e919907badad5314418e0a09e275926f8235" => :mavericks
    sha256 "aeb5da8a05d9b085c295196e19e2b3a42636e4592adf772b250103f6ed2bb872" => :mountain_lion
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
