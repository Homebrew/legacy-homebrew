class Camlp4 < Formula
  desc "Tool to write extensible parsers in OCaml"
  homepage "https://github.com/ocaml/camlp4"
  url "https://github.com/ocaml/camlp4/archive/4.02+6.tar.gz"
  sha256 "820c35b69fdff3225bda6045fabffe5d7c54dda00fb157444ac8bda5e1778d45"
  version "4.02.2+6"
  head "https://github.com/ocaml/camlp4.git"
  revision 1

  bottle do
    cellar :any
    sha256 "c04f0052bceed26bf5432a1304f13b4a15fae8757f530776874b714c50754c7a" => :yosemite
    sha256 "586755085fa262615cbd9bbc5a869351ffec0dcf142113fbfc80c253be98eb06" => :mavericks
    sha256 "a4a1d70eb2002d3773f4a1d9ae989b613d8b3772c02baacabbbba0309463c7ff" => :mountain_lion
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
