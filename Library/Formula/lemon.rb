class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "http://www.hwaci.com/sw/lemon/"
  url "https://tx97.net/pub/distfiles/lemon-1.69.tar.bz2"
  sha256 "bc7c1cae233b6af48f4b436ee900843106a15bdb1dc810bc463d8c6aad0dd916"

  bottle do
    sha256 "e9b8328c8d905424be43404911bff1296c16fbdd83ecfeab7b51917f31c81ab7" => :yosemite
    sha256 "a8120db2de1708f3ecd4bddc5775f90cf5c39a55010a90d01b8cd5f58325560e" => :mavericks
    sha256 "dd245cd856b28f4d14a3f34e243b29b032becf0809208db66bb4c550e4789a83" => :mountain_lion
  end

  def install
    (share/"lemon").install "lempar.c"

    # patch the parser generator to look for the 'lempar.c' template file where we've installed it
    inreplace "lemon.c", / = pathsearch\([^)]*\);/, " = \"#{share}/lemon/lempar.c\";"

    system ENV.cc, "-o", "lemon", "lemon.c"
    bin.install "lemon"
  end

  test do
    (testpath/"gram.y").write <<-EOS.undent
      %token_type {int}
      %left PLUS.
      %include {
        #include <iostream>
        #include "example1.h"
      }
      %syntax_error {
        std::cout << "Syntax error!" << std::endl;
      }
      program ::= expr(A).   { std::cout << "Result=" << A << std::endl; }
      expr(A) ::= expr(B) PLUS  expr(C).   { A = B + C; }
      expr(A) ::= INTEGER(B). { A = B; }
    EOS

    system "#{bin}/lemon", "gram.y"
    assert File.exist? "gram.c"
  end
end
