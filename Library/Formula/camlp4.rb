class Camlp4 < Formula
  desc "Tool to write extensible parsers in OCaml"
  homepage "https://github.com/ocaml/camlp4"
  url "https://github.com/ocaml/camlp4/archive/4.02+6.tar.gz"
  version "4.02.2+6"
  sha256 "820c35b69fdff3225bda6045fabffe5d7c54dda00fb157444ac8bda5e1778d45"
  head "https://github.com/ocaml/camlp4.git", :branch => "trunk"
  revision 1

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "2fbb2011ee0a44abdc5ce6cbdea7b1f271a00b903bd14dab9ecf3f5318571204" => :el_capitan
    sha256 "3a3bcb70dad5b897a8d1db8bf28fe15794de5f14249d00b88ce5a8411e5e4a9d" => :yosemite
    sha256 "08ca2278024819f625b4a0ca52b2cb931279c9d7ec1d9a55c9e9748c5f55cb15" => :mavericks
  end

  depends_on "ocaml"

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
