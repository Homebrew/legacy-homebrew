class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "http://flex.sourceforge.net"
  url "https://downloads.sourceforge.net/flex/flex-2.6.0.tar.bz2"
  sha256 "24e611ef5a4703a191012f80c1027dc9d12555183ce0ecd46f3636e587e9b8e9"

  bottle do
    sha256 "31607eeace06e7460d03b2a0bfb9b13f3ca5b0407eb3e80d75d3b4f1ec43ba0f" => :el_capitan
    sha256 "17d484fe7e7590ff764905676b2b1fc367df1bd4d0ca1632b009000bacb6398a" => :yosemite
    sha256 "38eee2c7e97f49acb62b03190bde9ca4c203d1046c681a1b92ba6085b56f705b" => :mavericks
    sha256 "3bbc5d00bcbc58f312ade24ed7c47369048720fa1e4af7e72259e8ff3b75d860" => :mountain_lion
  end

  keg_only :provided_by_osx, "Some formulae require a newer version of flex."

  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-shared",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.flex").write <<-EOS.undent
      CHAR   [a-z][A-Z]
      %%
      {CHAR}+      printf("%s", yytext);
      [ \\t\\n]+   printf("\\n");
      %%
      int main()
      {
        yyin = stdin;
        yylex();
      }
    EOS
    system "#{bin}/flex", "test.flex"
    system ENV.cc, "lex.yy.c", "-L#{lib}", "-lfl", "-o", "test"
    assert_equal shell_output("echo \"Hello World\" | ./test"), <<-EOS.undent
      Hello
      World
    EOS
  end
end
