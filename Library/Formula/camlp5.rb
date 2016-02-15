class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "http://camlp5.gforge.inria.fr/"
  url "http://camlp5.gforge.inria.fr/distrib/src/camlp5-6.14.tgz"
  sha256 "09f9ed12893d2ec39c88106af2306865c966096bedce0250f2fe52b67d2480e2"

  bottle do
    revision 1
    sha256 "9a2321af5082525322937a17a66fc75d8a7ccb94eb74099ddc33ceb8d1dbad0c" => :el_capitan
    sha256 "c0edde4ff0551c6e626adc73189959fbdb4342aafe9ae8fe9b41946254c0f322" => :yosemite
    sha256 "2ee8251c85a5860982063b9c1c3ed554c25410eb884aa35ade2a6a82866998c9" => :mavericks
  end

  deprecated_option "strict" => "with-strict"
  option "with-strict", "Compile in strict mode"

  depends_on "ocaml"

  def install
    if build.with? "strict"
      strictness = "-strict"
    else
      strictness = "-transitional"
    end

    system "./configure", "-prefix", prefix, "-mandir", man, strictness
    # this build fails if jobs are parallelized
    ENV.deparallelize
    system "make", "world.opt"
    system "make", "install"
  end
end
