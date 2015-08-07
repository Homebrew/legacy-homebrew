class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20141215.tar.gz"
  sha256 "2592967c123a31e1b6566ab9f6034e7a0a709d57d547097f05693baf96a46fa4"

  bottle do
    sha1 "a2d506915eb26d66fbf529fd48b906a3289601e3" => :yosemite
    sha1 "8a6e1f662272c5536d33645a3e67616d19ec7706" => :mavericks
    sha1 "7ab625d14199153fac46742c684e623e68590469" => :mountain_lion
  end

  depends_on "objective-caml"

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
