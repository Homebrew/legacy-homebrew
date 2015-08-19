class Sary < Formula
  desc "Suffix array library"
  homepage "http://sary.sourceforge.net/"
  url "http://sary.sourceforge.net/sary-1.2.0.tar.gz"
  sha256 "d4b16e32c97a253b546922d2926c8600383352f0af0d95e2938b6d846dfc6a11"

  bottle do
    cellar :any
    sha256 "1ef3eadf64fd9bcaeed1f01e7b03504fdcfbbe5bb65fe7e5da5aece9b73055a3" => :yosemite
    sha256 "b41f84ca9dc8bb27eeba82e1d13008f8b56a357ede1ab1987337561347cd6d94" => :mavericks
    sha256 "a1f528db66834372eac1e85513cbbfa8bc1242988bd31a986a9ea0fcec768b37" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test").write <<-EOS.undent
      Some text,
      this is the Sary formula, a suffix array library and tools,
      more text.
      more. text.
    EOS

    system "#{bin}/mksary", "test"
    assert File.exist? "test.ary"

    assert_equal "Some text,\nmore text.\nmore. text.",
      shell_output("#{bin}/sary text test").chomp
  end
end
