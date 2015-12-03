class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "http://coccinelle.lip6.fr/"
  url "http://coccinelle.lip6.fr/distrib/coccinelle-1.0.4.tgz"
  sha256 "7f823813a2ea299c0f6c01d8419b83c4dc6617116d32ba99d726443a1c22b06d"

  bottle do
    sha256 "8345aa22d8966d5a812a09c7eba291e3b4c62ca233795f2f4ac1ad7f5f718098" => :yosemite
    sha256 "7a6ab8f68cc53737b6f64246d720aa4090246014f9309e69293e0c5516193f62" => :mavericks
    sha256 "8a91d91164c21682355d050b84752a672d725027df95a32654a53aea02ff394f" => :mountain_lion
  end

  depends_on "ocaml"
  depends_on "camlp4"
  depends_on "opam" => :build
  depends_on "hevea" => :build

  def install
    opamroot = buildpath/"opamroot"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--no-setup"
    system "opam", "install", "ocamlfind"
    system "./configure", "--disable-dependency-tracking",
                          "--enable-release",
                          "--enable-ocaml",
                          "--enable-opt",
                          "--enable-ocaml",
                          "--with-pdflatex=no",
                          "--prefix=#{prefix}"
    system "opam", "config", "exec", "--", "make"
    system "make", "install"
  end
end
