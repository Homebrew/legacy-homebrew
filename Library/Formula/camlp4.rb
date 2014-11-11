require "formula"

class Camlp4 < Formula
  homepage "https://github.com/ocaml/camlp4"
  url "https://github.com/ocaml/camlp4/archive/4.02.1+1.tar.gz"
  sha1 "7d0f879517887299167f1c3eefa8f4d266d69183"
  version "4.02.1+1"
  head "https://github.com/ocaml/camlp4.git"

  bottle do
    cellar :any
    sha1 "0eb13f59de6a620e7663f3e865d0fae8d211abfa" => :yosemite
    sha1 "af24c6a58f16bd15875114bca320db8c3110d88d" => :mavericks
    sha1 "c0c7378b99240a65cec22fa505cc4711413e03ec" => :mountain_lion
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
