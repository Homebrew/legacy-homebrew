class Lemon < Formula
  homepage "http://www.hwaci.com/sw/lemon/"
  url "http://tx97.net/pub/distfiles/lemon-1.69.tar.bz2"
  sha256 "bc7c1cae233b6af48f4b436ee900843106a15bdb1dc810bc463d8c6aad0dd916"

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
