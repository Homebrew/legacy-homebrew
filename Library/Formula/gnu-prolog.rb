class GnuProlog < Formula
  desc "Prolog compiler with constraint solving"
  homepage "http://www.gprolog.org/"
  url "http://gprolog.univ-paris1.fr/gprolog-1.4.4.tar.gz"
  sha256 "18c0e9644b33afd4dd3cdf29f94c099ad820d65e0c99da5495b1ae43b4f2b18e"

  bottle do
    sha256 "d1145e39194fda08dd0653e90cb37b516fc0aaac7c4820462586b36fc5dbc7cf" => :yosemite
    sha256 "0c185324002089662da4d313b01d7fd6831ff477808cfc9b7a19f42449ba9f2f" => :mavericks
    sha256 "4e167ef6d2dddf1d52bb39a093accdde86ea94711b0e7507d5e0f2c1507e789b" => :mountain_lion
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
