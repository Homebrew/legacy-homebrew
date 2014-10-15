require "formula"

class Parrot < Formula
  homepage "http://www.parrot.org/"
  head "https://github.com/parrot/parrot.git"
  url "ftp://ftp.parrot.org/pub/parrot/releases/supported/6.6.0/parrot-6.6.0.tar.bz2"
  sha256 "08e9e02db952828f6ab71755be47f99ebc90894378f04d8e4d7f3bc623f79ff5"
  revision 2

  bottle do
    sha1 "490672e708d62a0c1fc5a38d6326d53f88636c18" => :mavericks
    sha1 "2ad6a39e1d4f9d655c3b1340b45074aaae49d637" => :mountain_lion
    sha1 "12a26f049a680a0669a3b43f76b709646b48ce08" => :lion
  end

  conflicts_with "rakudo-star"

  depends_on "gmp" => :optional
  depends_on "icu4c" => :optional
  depends_on "pcre" => :optional
  depends_on "readline" => :optional
  depends_on "libffi" => :optional

  def install
    system "perl", "Configure.pl", "--prefix=#{prefix}",
                                   "--mandir=#{man}",
                                   "--debugging=0",
                                   "--cc=#{ENV.cc}"

    system "make"
    system "make install"
    # Don't install this file in HOMEBREW_PREFIX/lib
    rm_rf lib/"VERSION"
  end

  test do
    path = testpath/"test.pir"
    path.write <<-EOS.undent
      .sub _main
        .local int i
        i = 0
      loop:
        print i
        inc i
        if i < 10 goto loop
      .end
    EOS

    out = `#{bin}/parrot #{path}`
    assert_equal "0123456789", out
    assert_equal 0, $?.exitstatus
  end
end
