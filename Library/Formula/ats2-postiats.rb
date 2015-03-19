class Ats2Postiats < Formula
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.1.9/ATS2-Postiats-0.1.9.tgz"
  sha1 "70e0239a55c7ab67fb8612a76acd87494e963fab"

  bottle do
    cellar :any
    sha256 "aab761ea4f3a8ec287df3193f3791e04d9872b1ac4212860fabfd48ae1c89ae6" => :yosemite
    sha256 "6833b7932e1ea5c136510528682bbe2aa4f2405961801632dbae60e1fc9e9f63" => :mavericks
    sha256 "ac4d75d70103af4f236ff6520d87c9024d9ad49f7d322f4c5801b2a343aac036" => :mountain_lion
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
