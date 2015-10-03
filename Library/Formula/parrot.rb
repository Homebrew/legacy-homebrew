class Parrot < Formula
  desc "Open source virtual machine (for Perl6, et al.)"
  homepage "http://www.parrot.org/"
  head "https://github.com/parrot/parrot.git"
  url "ftp://ftp.parrot.org/pub/parrot/releases/supported/6.9.0/parrot-6.9.0.tar.bz2"
  sha256 "ad5f3723c216675b9ebc2e3d3807d24fd13aa55e1eb3e7ffcad4062e0026f482"

  bottle do
    sha1 "8cadb0beb3984785d995a64847ed78b279798cee" => :yosemite
    sha1 "da39dec1f80b1fa5192ed3b72ca53b7333e8ca3b" => :mavericks
    sha1 "d09c985f1f51ecf6bed935da78311cb650b23ba7" => :mountain_lion
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
    system "make", "install"
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
