require "formula"

class Parrot < Formula
  homepage "http://www.parrot.org/"
  url "ftp://ftp.parrot.org/pub/parrot/releases/supported/6.3.0/parrot-6.3.0.tar.bz2"
  sha256 "8d64df21751770741dac263e621275f04ce7493db6f519e3f4886a085161a80d"

  devel do
    url "ftp://ftp.parrot.org/pub/parrot/releases/devel/6.5.0/parrot-6.5.0.tar.bz2"
    sha256 "1f45044f8dcfaafef795e93a91c8f4a55dd8347cc0359ce4dcf6f34f7bfff140"
  end

  head "https://github.com/parrot/parrot.git"

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
