class Ats2Postiats < Formula
  desc "ATS programming language implementation"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.2.4/ATS2-Postiats-0.2.4.tgz"
  sha256 "33365e1cab4f897ab24176a0988980dc4830bf8b35bf16daa8fb745006abb6a8"

  bottle do
    cellar :any
    sha256 "5eef2e2e5135bb713c29b64da2ac63d96acb16dbc76fe2b7248332405546495c" => :el_capitan
    sha256 "41eeebebef65ff56c3c655c2c3c7dc624c7702982912596bf33cde6d5ab00ece" => :yosemite
    sha256 "c29a2ac2b51304cb5f42ab7698257e6d098e85202d3453320be1abe480d90207" => :mavericks
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
