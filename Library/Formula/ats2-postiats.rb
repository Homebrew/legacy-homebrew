require "formula"

class Ats2Postiats < Formula
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.1.0/ATS2-Postiats-0.1.0.tgz"
  sha1 "7767db094f7f050edf30518866892b6cd0e2277e"

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
    File.open("hello.dats", "w") do |f|
      f.write <<-EOF.undent
        val _ = print ("Hello, world!\n")
        implement main0 () = ()
      EOF
    end
    system "#{bin}/patscc hello.dats -o hello"
    IO.popen("./hello", "r") do |pipe|
      assert_match "Hello, world!", pipe.read
    end
  end
end
