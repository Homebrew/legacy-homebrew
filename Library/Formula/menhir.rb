class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20151112.tar.gz"
  sha256 "06616e300ed2e5f4f2c74c58873fcd4b5f8f033b4f375f201049dafe4cd20e3a"

  bottle do
    sha256 "04253a1bc5f714e425074636699fdef28d60422bd163077321ee271eec310add" => :el_capitan
    sha256 "0a9d4d791b3a9467d6412cde9b7e2d308a4fcea7cabfac56d742da899add802a" => :yosemite
    sha256 "b9af60976a71b286966fa774403a292b44d169c6d0edff3b757a4b1b9cb3d79f" => :mavericks
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
