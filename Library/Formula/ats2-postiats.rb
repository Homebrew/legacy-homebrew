require "formula"

class Ats2Postiats < Formula
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.1.6/ATS2-Postiats-0.1.6.tgz"
  sha1 "32f093102c8e32197dc182fc7801c5d16bdc92e5"

  bottle do
    cellar :any
    sha1 "3805d6bdb7ed10e6dc06ec624e290f544fd0f7fb" => :yosemite
    sha1 "631beaaf1a7454a3fbbbe8b11bdf02567d57c1d0" => :mavericks
    sha1 "03ba510ac561f55cbecdc1aa5d74968b8ae2cf77" => :mountain_lion
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
