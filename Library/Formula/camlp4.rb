class Camlp4 < Formula
  desc "Tool to write extensible parsers in OCaml"
  homepage "https://github.com/ocaml/camlp4"
  url "https://github.com/ocaml/camlp4/archive/4.02+6.tar.gz"
  sha1 "6dd7e591dfde94c44576dba9b847279ffb92c889"
  version "4.02.2+6"
  head "https://github.com/ocaml/camlp4.git"

  bottle do
    cellar :any
    sha256 "f02f03f8833600db52b476fe8af881496d3dac597cd2c027026e4e77fcde465b" => :yosemite
    sha256 "2e9a8659e9ddd0b94f57696d46d4abab56576b4a5f54cd94de381586ffdaf168" => :mavericks
    sha256 "c8a26afba24e74c42f667e2c561a61a0348748ce7506574dffaa070a3912e0e3" => :mountain_lion
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
