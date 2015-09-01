class Ats2Postiats < Formula
  desc "ATS programming language implementation"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.2.2/ATS2-Postiats-0.2.2.tgz"
  sha256 "3a32aa65928d79cd17328475bd85c24dc83fb7c429826eb857beb73dad446525"

  bottle do
    cellar :any
    sha256 "a011b5d66c72bcff0e779db8db96570b28baab1898bbd22cbec2df9998ad2caf" => :yosemite
    sha256 "702f83b5149cad7df30c2cecc75e2e2ec8561f3213a63ecd23d5a95d3d1eee76" => :mavericks
    sha256 "c94738700929ddec7ce7b100c341e7c53612200462ba7164697f74903eab672c" => :mountain_lion
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
