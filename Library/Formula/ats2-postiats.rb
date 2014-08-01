require "formula"

class Ats2Postiats < Formula
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.1.0/ATS2-Postiats-0.1.0.tgz"
  sha1 "7767db094f7f050edf30518866892b6cd0e2277e"

  bottle do
    cellar :any
    sha1 "d02cf136334e7c813a8a7dd041d6b1b24f352a85" => :mavericks
    sha1 "59786888cee7152fdaf7a27f46d98e667c313339" => :mountain_lion
    sha1 "b544d4480ad688d9d3f1320d25c5a784a215f49d" => :lion
  end

  depends_on "gmp"

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
