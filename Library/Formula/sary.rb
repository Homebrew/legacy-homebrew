class Sary < Formula
  homepage "http://sary.sourceforge.net/"
  url "http://sary.sourceforge.net/sary-1.2.0.tar.gz"
  sha256 "d4b16e32c97a253b546922d2926c8600383352f0af0d95e2938b6d846dfc6a11"

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
