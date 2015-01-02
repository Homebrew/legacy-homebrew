class Flex < Formula
  homepage "http://flex.sourceforge.net"
  url "https://downloads.sourceforge.net/flex/flex-2.5.37.tar.bz2"
  sha1 "db4b140f2aff34c6197cab919828cc4146aae218"

  bottle do
    revision 1
    sha1 "0a2bb0ce9a49330e5fd40b6e409a353972cf8840" => :yosemite
    sha1 "0dd7fc9c36a6258b2e456e7dd0c5818d07e2a2ea" => :mavericks
    sha1 "69b5f449a9c0bf5fd37f999dca5ccfd120a6f389" => :mountain_lion
  end

  keg_only :provided_by_osx, "Some formulae require a newer version of flex."

  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking",
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
