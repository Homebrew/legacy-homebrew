class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "http://os.ghalkes.nl/dwdiff.html"
  url "http://os.ghalkes.nl/dist/dwdiff-2.1.0.tar.bz2"
  sha256 "45308f2f07c08c75c6ebd1eae3e3dcf7f836e5af1467cefc1b4829777c07743a"

  bottle do
    sha256 "ed7c510138b40149b05bc252544f8cdf338423d11cab99c7c39ba53ecb5e5d03" => :yosemite
    sha256 "f0522d79672fb2836fb26b20ca438284de4a0031cc79e44fd6c27662588ffdc4" => :mavericks
    sha256 "3f311aed9d84dc99a1e9d9207b7db31bc23e3e230d63511958db15784e45c1fd" => :mountain_lion
  end

  depends_on "gettext"
  depends_on "icu4c"

  def install
    gettext = Formula["gettext"]
    icu4c = Formula["icu4c"]
    ENV.append "CFLAGS", "-I#{gettext.include} -I#{icu4c.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib} -L#{icu4c.lib} -lintl"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Remove non-English man pages
    (man/"nl").rmtree
    (man/"nl.UTF-8").rmtree
    (share/"locale/nl").rmtree
  end

  test do
    (testpath/"a").write "I like beers"
    (testpath/"b").write "I like formulae"
    diff = shell_output("#{bin}/dwdiff a b", 1)
    assert_equal "I like [-beers-] {+formulae+}", diff
  end
end
