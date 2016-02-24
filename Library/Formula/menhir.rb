class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20151112.tar.gz"
  sha256 "06616e300ed2e5f4f2c74c58873fcd4b5f8f033b4f375f201049dafe4cd20e3a"

  bottle do
    sha256 "fb633f4c9db5677f8bb2eb76d09f3ffafb9a26c9fcf6ea50b657208614e01aa5" => :yosemite
    sha256 "fea7b5ae07c9b82ac1a5a65c14f1ebf825ab3b9eddde9f5c1f42dbea87e221a3" => :mavericks
    sha256 "734d3bceb3efc9b77381e391182cd15f01752dc15eea3049c89f9379fbd22f25" => :mountain_lion
  end

  depends_on "ocaml"

  # Workaround parallelized build failure by separating all steps
  # Submitted to menhir-list@yquem.inria.fr on 24th Feb 2016.
  patch :DATA

  def install
    system "make", "PREFIX=#{prefix}", "all"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.mly").write <<-EOS.undent
      %token PLUS TIMES EOF
      %left PLUS
      %left TIMES
      %token<int> INT
      %start<int> prog
      %%

      prog: x=exp EOF { x }

      exp: x = INT { x }
      |    lhs = exp; op = op; rhs = exp  { op lhs rhs }

      %inline op: PLUS { fun x y -> x + y }
                | TIMES { fun x y -> x * y }
    EOS

    system "#{bin}/menhir", "--dump", "--explain", "--infer", "test.mly"
    assert File.exist? "test.ml"
    assert File.exist? "test.mli"
  end
end

__END__
diff --git a/Makefile b/Makefile
index f426f5d..54f397e 100644
--- a/Makefile
+++ b/Makefile
@@ -116,7 +116,11 @@ all:
 	  echo "let ocamlfind = false" >> src/installation.ml ; \
 	fi
 # Compile the library modules and the Menhir executable.
-	@ $(MAKE) -C src library bootstrap
+	@ $(MAKE) -C src library
+	@ $(MAKE) -C src .versioncheck
+	@ $(MAKE) -C src stage1
+	@ $(MAKE) -C src stage2
+	@ $(MAKE) -C src stage3
 # The source file menhirLib.ml is created by concatenating all of the source
 # files that make up MenhirLib. This file is not needed to compile Menhir or
 # MenhirLib. It is installed at the same time as MenhirLib and is copied by
