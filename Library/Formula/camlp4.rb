require "formula"

class Camlp4 < Formula
  version '4.02.1+1'
  homepage "https://github.com/ocaml/camlp4"
  url "https://github.com/ocaml/camlp4/archive/4.02.1+1.tar.gz"
  sha1 "7d0f879517887299167f1c3eefa8f4d266d69183"
  head "https://github.com/ocaml/camlp4.git"

  depends_on "objective-caml"

  def install
    # this build fails if jobs are parallelized
    ENV.deparallelize
    system "./configure", "--bindir=#{bin}",
                          "--libdir=#{HOMEBREW_PREFIX}/lib/ocaml",
                          "--pkgdir=#{HOMEBREW_PREFIX}/lib/ocaml/camlp4"
    system "make", "all"
    system "make", "install", "LIBDIR=#{prefix}/lib/ocaml",
                              "PKGDIR=#{prefix}/lib/ocaml/camlp4"
  end

  test do
    (testpath/"foo.ml").write("type t = Homebrew | Rocks")
    system "#{bin}/camlp4", "-parser", "OCaml", "-printer", "OCamlr", "foo.ml", "-o", (testpath/"foo.ml.out")
    assert_equal "type t = [ Homebrew | Rocks ];", (testpath/"foo.ml.out").read.strip
  end

end
