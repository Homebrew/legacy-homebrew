class Camlp5 < Formula
  desc "Camlp5 is a preprocessor and pretty-printer for OCaml"
  homepage "http://camlp5.gforge.inria.fr/"
  url "http://camlp5.gforge.inria.fr/distrib/src/camlp5-6.14.tgz"
  sha256 "09f9ed12893d2ec39c88106af2306865c966096bedce0250f2fe52b67d2480e2"

  bottle do
    sha256 "0f8a0cf06129ef87819e72d9eba821322d9d41e6ef85ffda19ce7753ac7e8b3e" => :yosemite
    sha256 "4780b3746a506a52e9921fef376f47e283670610c67875182979cd9bf7e8f2a0" => :mavericks
    sha256 "60312c75054d1db597c8afaf2d0563d41e192480531b74b2ad40908e36bbfb8b" => :mountain_lion
  end

  depends_on "ocaml"

  option "strict", "Compile in strict mode"

  def install
    if build.include? "strict"
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
