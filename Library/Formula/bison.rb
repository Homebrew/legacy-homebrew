class Bison < Formula
  homepage "http://www.gnu.org/software/bison/"
  url "http://ftpmirror.gnu.org/bison/bison-3.0.2.tar.gz"
  mirror "http://ftp.gnu.org/gnu/bison/bison-3.0.2.tar.gz"
  sha1 "4bbb9a1bdc7e4328eb4e6ef2479b3fe15cc49e54"

  bottle do
    revision 1
    sha1 "12fdce885665b82a723b815f40afa81f8765e1ec" => :yosemite
    sha1 "59bd723116afc1a23813413e113d36c0a4361a3a" => :mavericks
    sha1 "995e0372cc6b74c5475f740b83c17963fddbf320" => :mountain_lion
  end

  keg_only :provided_by_osx, "Some formulae require a newer version of bison."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.y").write <<-EOS.undent
      %{ #include <iostream>
         using namespace std;
         extern void yyerror (char *s);
         extern int yylex ();
      %}
      %start prog
      %%
      prog:  //  empty
          |  prog expr '\\n' { cout << "pass"; exit(0); }
          ;
      expr: '(' ')'
          | '(' expr ')'
          |  expr expr
          ;
      %%
      char c;
      void yyerror (char *s) { cout << "fail"; exit(0); }
      int yylex () { cin.get(c); return c; }
      int main() { yyparse(); }
    EOS
    system "#{bin}/bison", "test.y"
    system ENV.cxx, "test.tab.c", "-o", "test"
    assert_equal "pass", shell_output("echo \"((()(())))()\" | ./test")
    assert_equal "fail", shell_output("echo \"())\" | ./test")
  end
end
