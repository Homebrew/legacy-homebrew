require "formula"

class Ats2Postiats < Formula
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.1.5/ATS2-Postiats-0.1.5.tgz"
  sha1 "8775d3ddfba30e61a50a3b3a8c7573a5dde716d1"

  bottle do
    cellar :any
    sha1 "53570725cd5fee34d3710a3908c3a5a0cd800dac" => :yosemite
    sha1 "34c54e59d4e45a2297cec3a65e9ac2e4e0a5afb0" => :mavericks
    sha1 "0eb7693e9e40e9bed65460f29ddbcf9c8e8aec29" => :mountain_lion
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
