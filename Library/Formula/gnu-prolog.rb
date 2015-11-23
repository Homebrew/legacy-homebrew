class GnuProlog < Formula
  desc "Prolog compiler with constraint solving"
  homepage "http://www.gprolog.org/"
  url "http://gprolog.univ-paris1.fr/gprolog-1.4.4.tar.gz"
  sha256 "18c0e9644b33afd4dd3cdf29f94c099ad820d65e0c99da5495b1ae43b4f2b18e"

  bottle do
    sha1 "8dc1b5782b6fb5e89c62fe3f5b07a908ddff6850" => :yosemite
    sha1 "faf4b9bd8c63bb89bc2217cde8ce0ea00866ddf8" => :mavericks
    sha1 "92366ec981d47a8f30a602b1b40cb4a1de99922c" => :mountain_lion
  end

  # Upstream patch:
  # http://sourceforge.net/p/gprolog/code/ci/784b3443a0a2f087c1d1e7976739fa517efe6af6
  patch do
    url "https://gist.githubusercontent.com/jacknagel/7549696/raw/3078eef282ca141c95a0bf74396f4248bbe34775/gprolog-clang.patch"
    sha256 "3b47551d96f23ab697f37a68ab206219ee29f747bc46b9f0cae9b60c5dafa3b2"
  end

  def install
    cd "src" do
      system "./configure", "--prefix=#{prefix}", "--with-doc-dir=#{doc}"
      ENV.deparallelize
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.pl").write <<-EOS.undent
      :- initialization(main).
      main :- write('Hello World!'), nl, halt.
    EOS
    system "#{bin}/gplc", "test.pl"
    assert_match /Hello World!/, shell_output("./test")
  end
end
