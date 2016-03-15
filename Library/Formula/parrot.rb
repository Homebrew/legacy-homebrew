class Parrot < Formula
  desc "Open source virtual machine (for Perl6, et al.)"
  homepage "http://www.parrot.org/"
  head "https://github.com/parrot/parrot.git"

  stable do
    url "ftp://ftp.parrot.org/pub/parrot/releases/supported/8.1.0/parrot-8.1.0.tar.bz2"
    sha256 "caf356acab64f4ea50595a846808e81d0be8ada8267afbbeb66ddb3c93cb81d3"

    # remove at 8.2.0, already in HEAD
    patch do
      url "https://github.com/parrot/parrot/commit/7524bf5384ddebbb3ba06a040f8acf972aa0a3ba.diff"
      sha256 "170f63df33fa2dc870902bd703c371bb6d601b515618f5830ab921bffa22e87b"
    end

    # remove at 8.2.0, already in HEAD
    patch do
      url "https://github.com/parrot/parrot/commit/854aec65d6de8eaf5282995ab92100a2446f0cde.diff"
      sha256 "dfe8b5e26b104f8fb2c1efe0a8316ffcba399463bd164c22e7cf2327fac2540e"
    end
  end

  bottle do
    sha256 "6c03426ea421562a7ae6489c93423f047d5bc2cbc6f8e9fd5ad6ae48d3096d21" => :yosemite
    sha256 "5f071956ca3f5ba7eab6b571bd9a77b059ed80af7ed1d5a8857aba5819f1ac0f" => :mavericks
    sha256 "c6deb6d7f91f91aa426a1c5604f3c9684fee81261d570f1e3b852e4a194262a1" => :mountain_lion
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
