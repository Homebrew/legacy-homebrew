class Ats2Postiats < Formula
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.1.8/ATS2-Postiats-0.1.8.tgz"
  sha1 "00f7489375a834c902e08b248dac197c770bbf88"

  bottle do
    cellar :any
    sha1 "c4aa7ad5059cd88680dd560b7b11839bfe17b26a" => :yosemite
    sha1 "518d0eac9f590a0eca8f4b8734270f1874bf532c" => :mavericks
    sha1 "6fcef0c5e1a94ff4f4a3eae9059cd03d7cb83b9d" => :mountain_lion
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
