class Ats2Postiats < Formula
  desc "ATS programming language implementation"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.1.13/ATS2-Postiats-0.1.13.tgz"
  sha1 "d6cc8b5bcd8a323701d7c6a86cf4466ad36af4b4"

  bottle do
    cellar :any
    sha256 "07927a049396017ed2afeaf0eb71134b5759e1864535ef38a2b3ffbda7df9f4b" => :yosemite
    sha256 "61a899de07271245f29713e3f52ecfe9c365d0cb9deb07745a6fec4a895520c9" => :mavericks
    sha256 "1097d605c57f3baccb3a63acbd9185f5d33c1edcd2c7bdebbe0ad633d09d84ef" => :mountain_lion
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
