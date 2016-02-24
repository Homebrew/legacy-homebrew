class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20141215.tar.gz"
  sha256 "2592967c123a31e1b6566ab9f6034e7a0a709d57d547097f05693baf96a46fa4"

  bottle do
    sha256 "fb633f4c9db5677f8bb2eb76d09f3ffafb9a26c9fcf6ea50b657208614e01aa5" => :yosemite
    sha256 "fea7b5ae07c9b82ac1a5a65c14f1ebf825ab3b9eddde9f5c1f42dbea87e221a3" => :mavericks
    sha256 "734d3bceb3efc9b77381e391182cd15f01752dc15eea3049c89f9379fbd22f25" => :mountain_lion
  end

  depends_on "ocaml"

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "all", "install"
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
