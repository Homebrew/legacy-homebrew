class Camlp4 < Formula
  desc "Tool to write extensible parsers in OCaml"
  homepage "https://github.com/ocaml/camlp4"
  url "https://github.com/ocaml/camlp4/archive/4.02.1+2.tar.gz"
  sha1 "ad43587c2bdc46d5d0f028857f5ce90bc9ce7ab5"
  version "4.02.1+2"
  head "https://github.com/ocaml/camlp4.git"

  bottle do
    cellar :any
    sha1 "f8f1ff8b4c3cb9ca0a691e56c32615b8b1c43912" => :yosemite
    sha1 "5def247ba43daed533e1b1a88bf2a3dcc3bf4391" => :mavericks
    sha1 "68c208492b208b060b66418e77dedc059796c2b2" => :mountain_lion
  end

  depends_on "objective-caml"

  def install
    # this build fails if jobs are parallelized
    ENV.deparallelize
    system "./configure", "--bindir=#{bin}",
                          "--libdir=#{HOMEBREW_PREFIX}/lib/ocaml",
                          "--pkgdir=#{HOMEBREW_PREFIX}/lib/ocaml/camlp4"
    system "make", "all"
    system "make", "install", "LIBDIR=#{lib}/ocaml",
                              "PKGDIR=#{lib}/lib/ocaml/camlp4"
  end

  test do
    (testpath/"foo.ml").write "type t = Homebrew | Rocks"
    system "#{bin}/camlp4", "-parser", "OCaml", "-printer", "OCamlr",
                            "foo.ml", "-o", testpath/"foo.ml.out"
    assert_equal "type t = [ Homebrew | Rocks ];",
                 (testpath/"foo.ml.out").read.strip
  end
end
