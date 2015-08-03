class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "http://flex.sourceforge.net"
  url "https://downloads.sourceforge.net/flex/flex-2.5.39.tar.bz2"
  sha256 "add2b55f3bc38cb512b48fad7d72f43b11ef244487ff25fc00aabec1e32b617f"

  bottle do
    sha1 "a1f8a76465942c6187b00dfa931ac56f22b7ba00" => :yosemite
    sha1 "533d4351154274d9d68f517b85e1de8e524b2bd5" => :mavericks
    sha1 "524d471123dbd4ca812e3fc3778afd865df616e6" => :mountain_lion
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
